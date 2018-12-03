//
//  TGRESTInMemoryStore.m
//  
//
//  Created by John Tumminaro on 4/26/14.
//
//

#import "TGRESTInMemoryStore.h"
#import "TGRESTResource.h"
#import "TGRESTEasyLogging.h"

@interface TGRESTInMemoryStore ()

@property (atomic, strong) NSMutableDictionary *inMemoryDatastore;
@property (nonatomic, strong) NSOperationQueue *dbQueue;

@end

@implementation TGRESTInMemoryStore

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.inMemoryDatastore = [NSMutableDictionary new];
        self.dbQueue = [NSOperationQueue new];
        self.dbQueue.maxConcurrentOperationCount = 1;
    }
    
    return self;
}

- (NSUInteger)countOfObjectsForResource:(TGRESTResource *)resource
{
    return [[self getAllObjectsForResource:resource error:nil] count];
}

- (NSDictionary *)getDataForObjectOfResource:(TGRESTResource *)resource
                              withPrimaryKey:(NSString *)primaryKey
                                       error:(NSError * __autoreleasing *)error
{
    NSParameterAssert(primaryKey);
    NSParameterAssert(resource);
    
    NSMutableDictionary *objects = self.inMemoryDatastore[resource.name];
    NSDictionary *object;
    if (resource.primaryKeyType == TGPropertyTypeInteger) {
        if (objects[[NSNumber numberWithInteger:[primaryKey integerValue]]] == [NSNull null]) {
            if (error) {
                *error = [NSError errorWithDomain:TGRESTStoreErrorDomain code:TGRESTStoreObjectAlreadyDeletedErrorCode userInfo:nil];
            }
            return nil;
        }
        object = objects[[NSNumber numberWithInteger:[primaryKey integerValue]]];
    } else {
        if (objects[primaryKey] == [NSNull null]) {
            if (error) {
                *error = [NSError errorWithDomain:TGRESTStoreErrorDomain code:TGRESTStoreObjectAlreadyDeletedErrorCode userInfo:nil];
            }
            return nil;
        }
        object = objects[primaryKey];
    }
    
    if (!object && error) {
        *error = [NSError errorWithDomain:TGRESTStoreErrorDomain code:TGRESTStoreObjectNotFoundErrorCode userInfo:nil];
    }
    
    return object;
}

- (NSArray *)getDataForObjectsOfResource:(TGRESTResource *)resource
                                  withParent:(TGRESTResource *)parent
                            parentPrimaryKey:(NSString *)key
                                       error:(NSError * __autoreleasing *)error
{
    NSParameterAssert(resource);
    NSParameterAssert(parent);
    NSParameterAssert(key);
    
    NSError *lookup;
    [self getDataForObjectOfResource:parent withPrimaryKey:key error:&lookup];
    
    if (lookup) {
        if (error) {
            *error = [NSError errorWithDomain:TGRESTStoreErrorDomain code:TGRESTStoreObjectNotFoundErrorCode userInfo:nil];
        }
        
        return nil;
    }
    
    NSMutableDictionary *objects = self.inMemoryDatastore[resource.name];
    id normalizedKey;
    if (parent.primaryKeyType == TGPropertyTypeInteger) {
        normalizedKey = [NSNumber numberWithInteger:[key integerValue]];
    } else {
        normalizedKey = key;
    }
    NSPredicate *matchPredicate = [NSPredicate predicateWithFormat:@"self.%@ == %@", resource.foreignKeys[parent.name], normalizedKey];
    NSMutableArray *returnArray = [NSMutableArray new];
    
    for (NSDictionary *object in objects.allValues) {
        if ([matchPredicate evaluateWithObject:object]) {
            [returnArray addObject:object];
        }
    }
    
    NSSortDescriptor *sortByID = [NSSortDescriptor sortDescriptorWithKey:resource.primaryKey ascending:YES];
    
    return [returnArray sortedArrayUsingDescriptors:@[sortByID]];
}

- (NSArray *)getAllObjectsForResource:(TGRESTResource *)resource
                                error:(NSError * __autoreleasing *)error
{
    NSParameterAssert(resource);

    NSMutableDictionary *objects = self.inMemoryDatastore[resource.name];
    if (!objects) {
        if (error) {
            *error = [NSError errorWithDomain:TGRESTStoreErrorDomain code:TGRESTStoreUnknownErrorCode userInfo:nil];
        }
        return nil;
    } else if (objects.count == 0) {
        return @[];
    }
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self != %@", [NSNull null]];
    NSSet *filteredKeys = [objects keysOfEntriesPassingTest:^BOOL(id key, id obj, BOOL *stop) {
        return [predicate evaluateWithObject:obj];
    }];
    NSArray *filteredObjects = [objects objectsForKeys:[filteredKeys allObjects] notFoundMarker:@""];
    return [filteredObjects sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:resource.primaryKey ascending:YES]]];
}

- (NSDictionary *)createNewObjectForResource:(TGRESTResource *)resource
                              withProperties:(NSDictionary *)properties
                                       error:(NSError * __autoreleasing *)error
{
    NSParameterAssert(properties);
    NSParameterAssert(resource);
    
    __block NSDictionary *newObjectDictionary;
    
    NSBlockOperation *write = [NSBlockOperation blockOperationWithBlock:^{
        NSMutableDictionary *resourceDictionary = [self.inMemoryDatastore objectForKey:resource.name];
        if (!resourceDictionary) {
            if (error) {
                *error = [NSError errorWithDomain:TGRESTStoreErrorDomain code:TGRESTStoreUnknownErrorCode userInfo:nil];
            }
            newObjectDictionary = nil;
        }
        NSUInteger newPrimaryKey = [resourceDictionary allKeys].count + 1;
        id newPrimaryKeyObject;
        if (resource.primaryKeyType == TGPropertyTypeInteger) {
            newPrimaryKeyObject = [NSNumber numberWithInteger:newPrimaryKey];
        } else {
            newPrimaryKeyObject = [NSString stringWithFormat:@"%lu", (unsigned long)newPrimaryKey];
        }
        
        NSMutableDictionary *propertyDictionary = [NSMutableDictionary dictionaryWithDictionary:properties];
        [propertyDictionary setObject:newPrimaryKeyObject forKey:resource.primaryKey];
        for (NSString *key in resource.model.allKeys) {
            if (!propertyDictionary[key]) {
                [propertyDictionary setObject:[NSNull null] forKey:key];
            }
        }
        newObjectDictionary = [NSDictionary dictionaryWithDictionary:propertyDictionary];
        [resourceDictionary setObject:newObjectDictionary forKey:newPrimaryKeyObject];
    }];
    
    [self.dbQueue addOperation:write];
    
    [write waitUntilFinished];
    
    return newObjectDictionary;
}

- (NSDictionary *)modifyObjectOfResource:(TGRESTResource *)resource
                          withPrimaryKey:(NSString *)primaryKey
                          withProperties:(NSDictionary *)properties
                                   error:(NSError * __autoreleasing *)error
{
    NSParameterAssert(primaryKey);
    NSParameterAssert(resource);
    NSParameterAssert(properties);
    
    __block NSDictionary *updatedObject;
    __block NSError *blockError;
    __weak typeof(self) weakSelf = self;
    
    NSBlockOperation *write = [NSBlockOperation blockOperationWithBlock:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;

        NSError *getError;
        NSDictionary *object = [self getDataForObjectOfResource:resource withPrimaryKey:primaryKey error:&getError];
        if (getError) {
            blockError = getError;
            updatedObject = nil;
        } else {
            NSMutableDictionary *mergeDict = [NSMutableDictionary dictionaryWithDictionary:object];
            [mergeDict addEntriesFromDictionary:properties];
            updatedObject = [NSDictionary dictionaryWithDictionary:mergeDict];
            
            NSMutableDictionary *resourceDictionary = [strongSelf.inMemoryDatastore objectForKey:resource.name];
            if (resource.primaryKeyType == TGPropertyTypeInteger) {
                [resourceDictionary setObject:updatedObject forKey:[NSNumber numberWithInteger:[primaryKey integerValue]]];
            } else {
                [resourceDictionary setObject:updatedObject forKey:primaryKey];
            }
        }
    }];
    
    [self.dbQueue addOperation:write];
    
    [write waitUntilFinished];
    
    if (error) {
        *error = blockError;
    }
    
    return updatedObject;
}

- (BOOL)deleteObjectOfResource:(TGRESTResource *)resource
                withPrimaryKey:(NSString *)primaryKey
                         error:(NSError * __autoreleasing *)error
{
    NSParameterAssert(resource);
    NSParameterAssert(primaryKey);
    
    __block BOOL success;
    __weak typeof(self) weakSelf = self;
    __block NSError *blockError;
    
    NSBlockOperation *write = [NSBlockOperation blockOperationWithBlock:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        NSMutableDictionary *objects = strongSelf.inMemoryDatastore[resource.name];
        id objectKey;
        if (resource.primaryKeyType == TGPropertyTypeInteger) {
            objectKey = [NSNumber numberWithInteger:[primaryKey integerValue]];
        } else {
            objectKey = primaryKey;
        }
        
        if (objects[objectKey] == [NSNull null]) {
            blockError = [NSError errorWithDomain:TGRESTStoreErrorDomain code:TGRESTStoreObjectAlreadyDeletedErrorCode userInfo:nil];
            success = NO;
        } else {
            NSDictionary *object = objects[objectKey];
            
            if (!object) {
                blockError = [NSError errorWithDomain:TGRESTStoreErrorDomain code:TGRESTStoreObjectNotFoundErrorCode userInfo:nil];
                success = NO;
            } else {
                [objects setObject:[NSNull null] forKey:objectKey];
                
                for (TGRESTResource *child in resource.childResources) {
                    id normalizedKey;
                    if (resource.primaryKeyType == TGPropertyTypeInteger) {
                        normalizedKey = [NSNumber numberWithInteger:[primaryKey integerValue]];
                    } else {
                        normalizedKey = primaryKey;
                    }
                    NSString *fKeyName = child.foreignKeys[resource.name];
                    NSPredicate *matchPredicate = [NSPredicate predicateWithFormat:@"self.%@ == %@", child.foreignKeys[resource.name], normalizedKey];
                    NSMutableDictionary *childObjects = strongSelf.inMemoryDatastore[child.name];
                    
                    for (NSString *childKey in childObjects.allKeys) {
                        NSDictionary *existingChildDict = childObjects[childKey];
                        if ([matchPredicate evaluateWithObject:existingChildDict]) {
                            NSMutableDictionary *updateObject = [NSMutableDictionary dictionaryWithDictionary:existingChildDict];
                            [updateObject setObject:[NSNull null] forKey:fKeyName];
                            [childObjects setObject:[NSDictionary dictionaryWithDictionary:updateObject] forKey:childKey];
                        }
                    }
                }
                
                success = YES;
            }
        }
    }];
    
    [self.dbQueue addOperation:write];
    
    [write waitUntilFinished];
    
    if (error) {
        *error = blockError;
    }
    
    return success;
}

- (void)addResource:(TGRESTResource *)resource
{
    NSParameterAssert(resource);
    
    __weak typeof(self) weakSelf = self;
    NSBlockOperation *write = [NSBlockOperation blockOperationWithBlock:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf.inMemoryDatastore setObject:[NSMutableDictionary new] forKey:resource.name];
    }];
    
    [self.dbQueue addOperation:write];
    
    [write waitUntilFinished];
}

- (void)dropResource:(TGRESTResource *)resource
{
    NSParameterAssert(resource);
    
    __weak typeof(self) weakSelf = self;
    NSBlockOperation *write = [NSBlockOperation blockOperationWithBlock:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf.inMemoryDatastore removeObjectForKey:resource.name];
    }];
    
    [self.dbQueue addOperation:write];
    
    [write waitUntilFinished];
    
}

+ (NSString *)description
{
    return @"InMemory";
}

- (NSString *)description
{
    NSUInteger objectCount = 0;
    
    for (NSMutableArray *resourceArray in self.inMemoryDatastore.allValues) {
        objectCount = objectCount + resourceArray.count;
    }
    
    return [NSString stringWithFormat:@"%@ with %lu resources and %lu objects", [[self class] description], (unsigned long)self.inMemoryDatastore.allKeys.count, (unsigned long)objectCount];
}

@end
