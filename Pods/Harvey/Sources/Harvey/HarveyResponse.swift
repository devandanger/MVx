import Foundation

public final class HarveyResponse {

    public let url: URL
    public let data: Data
    public let statusCode: Int
    public let headers: [String: String]?

    // swiftlint:disable force_unwrapping
    internal lazy var httpUrlResponse: HTTPURLResponse = HTTPURLResponse(url: self.url, statusCode: self.statusCode, httpVersion: nil, headerFields: self.headers)!
    // swiftlint:enable force_unwrapping

    public init(url: URL, data: Data, statusCode: Int, headers: [String: String]?) {
        self.url = url
        self.data = data
        self.statusCode = statusCode
        self.headers = headers
    }
}
