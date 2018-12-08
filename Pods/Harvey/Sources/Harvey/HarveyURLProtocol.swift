import Foundation

public class HarveyURLProtocol: URLProtocol {

    public override func startLoading() {
        guard let dataSource = Harvey.dataSource(for: request),
            let stubbedResponse = dataSource.stubbedResponse(for: request) else {
                fatalError("Data source returned that it should stub, but the stub wasn't there.")
        }

        client?.urlProtocol(self, didLoad: stubbedResponse.data)
        client?.urlProtocol(self, didReceive: stubbedResponse.httpUrlResponse, cacheStoragePolicy: .notAllowed)
        client?.urlProtocolDidFinishLoading(self)
    }

    public override func stopLoading() {}

    public override class func canInit(with request: URLRequest) -> Bool {
        let shouldStub = Harvey.dataSource(for: request) != nil
        return shouldStub
    }

    public override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
}
