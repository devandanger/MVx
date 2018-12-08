import Foundation

public final class Harvey {

    private static var isStubbing = false
    private static var dataSources = [HarveyDataSourceProtocol]()

    public static func startStubbing() {
        guard !isStubbing else { return }

        URLProtocol.registerClass(HarveyURLProtocol.self)
        URLSessionConfiguration.harveySwizzle()
        isStubbing = true
    }

    public static func add(dataSource: HarveyDataSourceProtocol) {
        guard !dataSources.contains(where: { $0 === dataSource }) else { return }

        dataSources.append(dataSource)
    }

    public static func remove(dataSource: HarveyDataSourceProtocol) {
        guard let index = dataSources.index(where: { $0 === dataSource }) else { return }

        dataSources.remove(at: index)
    }

    public static func dataSource(for request: URLRequest) -> HarveyDataSourceProtocol? {
        let dataSources = self.dataSources.filter { $0.shouldStub(request: request) }
        let dataSourcesCount = dataSources.count

        guard dataSourcesCount <= 1 else {
            fatalError("\(dataSourcesCount) instances of dataSources wanted to stub this request.")
        }

        return dataSources.first
    }
}
