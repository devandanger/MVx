import Foundation

public extension URLSessionConfiguration {
    internal class func harveySwizzle() {
        guard
            let originalDefaultSelector = class_getClassMethod(URLSessionConfiguration.self, #selector(getter: URLSessionConfiguration.default)),
            let originalEphemeralSelector = class_getClassMethod(URLSessionConfiguration.self, #selector(getter: URLSessionConfiguration.ephemeral)),
            let swizzledDefaultSelector = class_getClassMethod(URLSessionConfiguration.self, #selector(URLSessionConfiguration.harveyDefault)),
            let swizzledEphemeralSelector = class_getClassMethod(URLSessionConfiguration.self, #selector(URLSessionConfiguration.harveyEphemeral)) else {
                return
        }
        method_exchangeImplementations(originalDefaultSelector, swizzledDefaultSelector)
        method_exchangeImplementations(originalEphemeralSelector, swizzledEphemeralSelector)
    }

    @objc private class func harveyDefault() -> URLSessionConfiguration {
        let configuration = harveyDefault()
        configuration.protocolClasses = [HarveyURLProtocol.self] as [AnyClass] + (configuration.protocolClasses ?? [])

        return configuration
    }

    @objc private class func harveyEphemeral() -> URLSessionConfiguration {
        let configuration = harveyEphemeral()
        configuration.protocolClasses = [HarveyURLProtocol.self] as [AnyClass] + (configuration.protocolClasses ?? [])

        return configuration
    }
}
