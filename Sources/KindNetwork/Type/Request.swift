//
//  KindKit
//

import Foundation

public struct Request {
    
    public let method: Request.Method
    public let path: Request.Path
    public let queryParams: [Request.Parameter]
    public let headers: [Request.Header]
    public let body: Request.Body?
    public let timeout: TimeInterval
    public let cachePolicy: URLRequest.CachePolicy
    public let redirect: RedirectOption

    public init(
        method: Method,
        path: Request.Path,
        queryParams: [Request.Parameter] = [],
        headers: [Request.Header] = [],
        body: Body? = nil,
        timeout: TimeInterval = 30,
        cachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy,
        redirect: RedirectOption = [ .enabled, .authorization ]
    ) {
        self.method = method
        self.path = path
        self.queryParams = queryParams
        self.headers = headers
        self.body = body
        self.timeout = timeout
        self.cachePolicy = cachePolicy
        self.redirect = redirect
    }

    public func urlRequest(provider: Provider) throws -> URLRequest {
        var components = try self.path.urlComponents(provider: provider)
        do {
            var params: [Request.Parameter] = (components.queryItems ?? []).map({
                if let value = $0.value {
                    return Request.Parameter(name: .raw($0.name), value: .raw(value))
                }
                return Request.Parameter(name: .raw($0.name), value: "")
            })
            for param in self.queryParams {
                if let index = params.firstIndex(where: { $0.name == param.name }) {
                    params[index] = .init(name: param.name, value: param.value)
                } else {
                    params.append(.init(name: param.name, value: param.value))
                }
            }
            if params.count > 0 {
                components.queryItems = params.map({
                    return URLQueryItem(name: $0.name.string, value: $0.value.string)
                })
            }
        }
        guard let url = components.url else {
            throw Error.Request.query(.encode(components))
        }
        var urlRequest = URLRequest(
            url: url,
            cachePolicy: self.cachePolicy,
            timeoutInterval: self.timeout
        )
        urlRequest.httpMethod = self.method.value
        var headers = provider.headers
        if let body = self.body {
            let build = try body.build()
            urlRequest.httpBody = build.data
            headers.append(contentsOf: build.headers)
        } else {
            headers.append(.contentLength(0))
        }
        if self.headers.isEmpty == false {
            headers.append(contentsOf: self.headers)
        }
        if headers.isEmpty == false {
            var httpHeaders: [String : String] = [:]
            for header in headers {
                httpHeaders[header.name] = header.value
            }
            urlRequest.allHTTPHeaderFields = httpHeaders
        }
        return urlRequest
    }
    
}
