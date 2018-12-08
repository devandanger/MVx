import Foundation

public protocol HarveyDataSourceProtocol: class {
    func shouldStub(request: URLRequest) -> Bool
    func stubbedResponse(for request: URLRequest) -> HarveyResponse?
}
