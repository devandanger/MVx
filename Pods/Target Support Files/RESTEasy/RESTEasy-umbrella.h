#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "RESTEasyCore.h"
#import "TGRESTController.h"
#import "TGRESTDefaultController.h"
#import "TGRESTDefaultSerializer.h"
#import "TGRESTInMemoryStore.h"
#import "TGRESTResource.h"
#import "TGRESTSerializer.h"
#import "TGRESTServer.h"
#import "TGRESTStore.h"

FOUNDATION_EXPORT double RESTEasyVersionNumber;
FOUNDATION_EXPORT const unsigned char RESTEasyVersionString[];

