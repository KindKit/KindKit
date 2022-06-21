//
//  KindKitApi
//

import Foundation
import KindKitCore

open class ApiRequest : IApiRequest {

    public var method: Method
    public var path: Path
    public var queryParams: [String: Any]
    public var trimArraySymbolsQueryParams: Bool
    public var headers: [String: String]
    public var bodyData: Data?
    public var bodyParams: [String: Any]?
    public var uploadItems: [UploadItem]?

    public var timeout: TimeInterval
    public var retries: TimeInterval
    public var delay: TimeInterval
    public var cachePolicy: URLRequest.CachePolicy
    public var redirect: ApiRequestRedirectOption
    #if DEBUG
    public var logging: ApiLogging = .never
    #endif

    public init(
        method: Method,
        path: Path,
        queryParams: [String: Any] = [:],
        trimArraySymbolsQueryParams: Bool = false,
        headers: [String: String] = [:],
        bodyData: Data? = nil,
        bodyParams: [String: Any]? = nil,
        uploadItems: [UploadItem]? = nil,
        timeout: TimeInterval = 30,
        retries: TimeInterval = 0,
        delay: TimeInterval = 1,
        cachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy,
        redirect: ApiRequestRedirectOption = [ .enabled, .authorization ]
    ) {
        self.method = method
        self.path = path
        self.queryParams = queryParams
        self.trimArraySymbolsQueryParams = trimArraySymbolsQueryParams
        self.headers = headers
        self.bodyData = bodyData
        self.bodyParams = bodyParams
        self.uploadItems = uploadItems
        self.timeout = timeout
        self.retries = retries
        self.delay = delay
        self.cachePolicy = cachePolicy
        self.redirect = redirect
    }

    public func set(queryParam: String, value: Any?) {
        if let safeValue = value {
            self.queryParams[queryParam] = safeValue
        } else {
            self.queryParams.removeValue(forKey: queryParam)
        }
    }

    public func get(queryParam: String) -> Any? {
        return self.queryParams[queryParam]
    }

    public func removeAllQueryParams() {
        self.queryParams.removeAll()
    }

    public func set(header: String, value: String?) {
        if let safeValue = value {
            self.headers[header] = safeValue
        } else {
            self.headers.removeValue(forKey: header)
        }
    }

    public func get(header: String) -> Any? {
        return self.headers[header]
    }

    public func removeAllHeaders() {
        self.headers.removeAll()
    }

    public func set(bodyParam: String, value: Any?) {
        if let safeValue = value {
            if self.bodyParams == nil {
                self.bodyParams = [:]
            }
            self.bodyParams![bodyParam] = safeValue
        } else {
            if self.bodyParams != nil {
                self.bodyParams!.removeValue(forKey: bodyParam)
            }
        }
    }

    public func get(bodyParam: String) -> Any? {
        if self.bodyParams != nil {
            return self.bodyParams![bodyParam]
        }
        return nil
    }

    public func removeAllBodyParams() {
        self.bodyParams = nil
    }

    public func urlRequest(provider: IApiProvider) -> URLRequest? {
        if var components = self._prepareUrlComponents(provider: provider) {
            components.percentEncodedQuery = self._prepareUrlQuery(query: components.query, provider: provider)
            if let url = components.url {
                var headers = self._prepareHeaders(provider: provider)
                let bodyData = self._prepareBody(provider: provider, headers: &headers)
                var rawHeaders: [String: String] = [:]
                headers.forEach({ rawHeaders[$0.0] = $0.1 })
                var urlRequest = URLRequest(url: url)
                switch self.method {
                case .get: urlRequest.httpMethod = "GET"
                case .post: urlRequest.httpMethod = "POST"
                case .put: urlRequest.httpMethod = "PUT"
                case .delete: urlRequest.httpMethod = "DELETE"
                case .custom(let name): urlRequest.httpMethod = name
                }
                urlRequest.cachePolicy = self.cachePolicy
                urlRequest.timeoutInterval = self.timeout
                urlRequest.allHTTPHeaderFields = rawHeaders
                if let body = bodyData {
                    urlRequest.httpBody = body
                }
                return urlRequest
            }
        }
        return nil
    }
    
    open func processing(headers: [(String, String)]) -> [(String, String)] {
        return headers
    }
    
    open func processing(queryParams: [(String, String)]) -> [(String, String)] {
        return queryParams
    }
    
    open func processing(bodyParams: [(String, String)]) -> [(String, String)] {
        return bodyParams
    }
    
}

public extension ApiRequest {
    
    enum Method {
        case get
        case post
        case put
        case delete
        case custom(_ name: String)
    }
    
    enum Path {
        case absolute(_ url: URL)
        case relative(_ url: String)
    }
    
    struct UploadItem {

        public let name: String
        public let filename: String?
        public let mimetype: String?
        public let data: Data

        public init(
            name: String,
            filename: String? = nil,
            mimetype: String? = nil,
            data: Data
        ) {
            self.name = name
            self.filename = filename
            self.mimetype = mimetype
            self.data = data
        }
        
        public init(
            name: String,
            filename: String? = nil,
            mimetype: String? = nil,
            build: @autoclosure () throws -> Data
        ) rethrows {
            self.name = name
            self.filename = filename
            self.mimetype = mimetype
            self.data = try build()
        }

    }
    
}

private extension ApiRequest {

    func _prepareUrlComponents(provider: IApiProvider) -> URLComponents? {
        switch self.path {
        case .absolute(let url):
            return URLComponents(string: url.absoluteString)
        case .relative(let url):
            guard let providerUrl = provider.url else { return nil }
            var string = providerUrl.absoluteString
            let safeUrl: String
            if url.hasPrefix("/") == true {
                let startIndex = url.index(url.startIndex, offsetBy: 1)
                let endIndex = url.endIndex
                safeUrl = String(url[startIndex ..< endIndex])
            } else {
                safeUrl = url
            }
            if string.hasSuffix("/") == true {
                string.append(safeUrl)
            } else {
                string.append("/\(safeUrl)")
            }
            if let url = URL(string: string) {
                return URLComponents(string: url.absoluteString)
            }
        }
        return nil
    }

    func _prepareUrlQuery(query: String?, provider: IApiProvider) -> String? {
        var rawParams: [String: Any] = [:]
        provider.queryParams.forEach({ (key, value) in
            rawParams[key] = value
        })
        if let query = query {
            let componentsQueryParams = query.components(
                pairSeparatedBy: "&",
                valueSeparatedBy: "="
            )
            componentsQueryParams.forEach({ (key, value) in
                rawParams[key] = value
            })
        }
        self.queryParams.forEach({ (key, value) in
            rawParams[key] = value
        })
        var result = String()
        let params = self._processingUrl(params: rawParams)
        params.forEach({ (key, value) in
            if result.count > 0 {
                result.append("&\(key)=\(value)")
            } else {
                result.append("\(key)=\(value)")
            }
        })
        if result.count > 0 {
            return result
        }
        return nil
    }
    
    func _processingUrl(params: [String: Any]) -> [(String, String)] {
        let flatParams = self._flat(params: params)
        if flatParams.count == 0 {
            return []
        }
        let processedParams = self.processing(queryParams: flatParams)
        if processedParams.count == 0 {
            return []
        }
        return self._encodeUrl(params: processedParams)
    }

    func _prepareHeaders(provider: IApiProvider) -> [(String, String)] {
        var rawHeaders: [String: String] = [:]
        provider.headers.forEach({ (key, value) in
            rawHeaders[key] = value
        })
        self.headers.forEach({ (key, value) in
            rawHeaders[key] = value
        })
        var flatHeaders: [(String, String)] = []
        rawHeaders.forEach({ (key, value) in
            flatHeaders.append((key, value))
        })
        return self.processing(headers: flatHeaders)
    }

    func _prepareBody(provider: IApiProvider, headers: inout [(String, String)]) -> Data? {
        if let bodyData = self.bodyData {
            self._insert(params: &headers, key: "Content-Length", value: "\(bodyData.count)")
            return bodyData
        } else {
            var rawParams: [String: Any] = [:]
            if let bodyParams = provider.bodyParams {
                bodyParams.forEach({ (key, value) in
                    rawParams[key] = value
                })
            }
            if let bodyParams = self.bodyParams {
                bodyParams.forEach({ (key, value) in
                    rawParams[key] = value
                })
            }
            if let uploadedItems = self.uploadItems {
                var data = Data()
                let boundary = UUID().uuidString
                let params = self._processingMultipartBody(params: rawParams)
                params.forEach({ (key, value) in
                    let encodeKey = self._encode(value: key)
                    let rowString = "--\(boundary)\r\nContent-Disposition: form-data; name=\"\(encodeKey)\"\r\n\r\n\(value)\r\n"
                    if let rowData = rowString.data(using: .ascii) {
                        data.append(rowData)
                    }
                })
                uploadedItems.forEach({ (uploadedItem) in
                    let encodeName = self._encode(value: uploadedItem.name)
                    var headerString = "--\(boundary)\r\nContent-Disposition: form-data; name=\"\(encodeName)\""
                    if let filename = uploadedItem.filename {
                        let encodeFilename = self._encode(value: filename)
                        headerString += "; filename=\"\(encodeFilename)\"\r\n"
                    } else {
                        headerString += "\r\n"
                    }
                    if let mimetype = uploadedItem.mimetype {
                        headerString += "Content-Type: \(mimetype)\r\n"
                    } else {
                        headerString += "\r\n"
                    }
                    headerString += "\r\n"
                    if let headerData = headerString.data(using: .ascii) {
                        data.append(headerData)
                    }
                    data.append(uploadedItem.data)
                    let footerString = "\r\n"
                    if let footerData = footerString.data(using: .ascii) {
                        data.append(footerData)
                    }
                })
                let footerString = "--\(boundary)--\r\n"
                if let footerData = footerString.data(using: .ascii) {
                    data.append(footerData)
                }
                self._insert(params: &headers, key: "Content-Type", value: "multipart/form-data; boundary=\(boundary)")
                self._insert(params: &headers, key: "Content-Length", value: "\(data.count)")
                return data
            } else if rawParams.count > 0 {
                var paramsString = String()
                let params = self._processingBody(params: rawParams)
                params.forEach({ (key, value) in
                    if paramsString.count > 0 {
                        paramsString.append("&\(key)=\(value)")
                    } else {
                        paramsString.append("\(key)=\(value)")
                    }
                })
                if let data = paramsString.data(using: .ascii) {
                    self._insert(params: &headers, key: "Content-Type", value: "application/x-www-form-urlencoded")
                    self._insert(params: &headers, key: "Content-Length", value: "\(data.count)")
                    return data
                }
            }
        }
        return nil
    }
    
    func _processingBody(params: [String: Any]) -> [(String, String)] {
        let flatParams = self._flat(params: params)
        if flatParams.count == 0 {
            return []
        }
        let processedParams = self.processing(bodyParams: flatParams)
        if processedParams.count == 0 {
            return []
        }
        return self._encodeBody(params: processedParams)
    }
    
    func _processingMultipartBody(params: [String: Any]) -> [(String, String)] {
        let flatParams = self._flat(params: params)
        if flatParams.count == 0 {
            return []
        }
        let processedParams = self.processing(bodyParams: flatParams)
        if processedParams.count == 0 {
            return []
        }
        return self._encodeMultipartBody(params: processedParams)
    }
    
    func _insert(params: inout [(String, String)], key: String, value: String) {
        if let index = params.firstIndex(where: { return $0.0 == key }) {
            params[index] = (key, value)
        } else {
            params.append((key, value))
        }
    }

    func _flat(params: [String: Any]) -> [(String, String)] {
        var flatParams: [(String, String)] = []
        params.forEach({ self._flat(flatParams: &flatParams, path: $0.0, value: $0.1) })
        return flatParams
    }

    func _flat(flatParams: inout [(String, String)], path: String, value: Any) {
        if let valueDictionary = value as? [String: Any] {
            valueDictionary.forEach { (subPath, subValue) in
                self._flat(flatParams: &flatParams, path: "\(path)[\(subPath)]", value: subValue)
            }
        } else if let valueArray = value as? [Any] {
            var index = 0
            valueArray.forEach({ (subValue) in
                self._flat(flatParams: &flatParams, path: "\(path)[\(index)]", value: subValue)
                index += 1
            })
        } else if let string = value as? String {
            flatParams.append((path, string))
        } else {
            flatParams.append((path, "\(value)"))
        }
    }
    
    func _encodeUrl(params: [(String, String)]) -> [(String, String)] {
        var result: [(String, String)] = []
        params.forEach({ (key, value) in
            let encodeKey = self._encode(key: key)
            let encodeValue = self._encode(value: value)
            result.append((encodeKey, encodeValue))
        })
        return result
    }
    
    func _encodeBody(params: [(String, String)]) -> [(String, String)] {
        var result: [(String, String)] = []
        params.forEach({ (key, value) in
            let encodeKey = self._encode(key: key)
            let encodeValue = self._encode(value: value)
            result.append((encodeKey, encodeValue))
        })
        return result
    }
    
    func _encodeMultipartBody(params: [(String, String)]) -> [(String, String)] {
        var result: [(String, String)] = []
        params.forEach({ (key, value) in
            let encodeKey = self._encode(key: key)
            result.append((encodeKey, value))
        })
        return result
    }

    func _encode(key: String) -> String {
        var string = key
        if self.trimArraySymbolsQueryParams == true {
            if let regexp = try? NSRegularExpression(pattern: "\\[[0-9]+\\]", options: []) {
                string = regexp.stringByReplacingMatches(in: string, options: [], range: NSRange(location: 0, length: string.count), withTemplate: "")
            }
        }
        return self._encode(value: string)
    }

    func _encode(value: Any) -> String {
        if let string = value as? String {
            return self._encode(value: string)
        } else {
            return self._encode(value: "\(value)")
        }
    }

    func _encode(value: String) -> String {
        return value.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
    }

}

#if DEBUG

extension ApiRequest : IDebug {

    open func debugString(_ buffer: inout String, _ headerIndent: Int, _ indent: Int, _ footerIndent: Int) {
        let nextIndent = indent + 1

        if headerIndent > 0 {
            buffer.append(String(repeating: "\t", count: headerIndent))
        }
        buffer.append("<\(String(describing: self))\n")

        DebugString("Method: \(self.method)\n", &buffer, indent, nextIndent, indent)
        switch self.path {
        case .absolute(let url):
            let debug = url.debugString(0, nextIndent, indent)
            DebugString("Url: \(debug)\n", &buffer, indent, nextIndent, indent)
        case .relative(let url):
            let debug = url.debugString(0, nextIndent, indent)
            DebugString("Url: \(debug)\n", &buffer, indent, nextIndent, indent)
        }
        if self.queryParams.count > 0 {
            let debug = self.queryParams.debugString(0, nextIndent, indent)
            DebugString("QueryParams: \(debug)\n", &buffer, indent, nextIndent, indent)
        }
        if self.headers.count > 0 {
            let debug = self.headers.debugString(0, nextIndent, indent)
            DebugString("Headers: \(debug)\n", &buffer, indent, nextIndent, indent)
        }
        if let bodyData = self.bodyData {
            var debug = String()
            bodyData.debugString(&debug, 0, nextIndent, indent)
            DebugString("Body: \(debug)\n", &buffer, indent, nextIndent, indent)
        } else {
            if let bodyParams = self.bodyParams {
                let debug = bodyParams.debugString(0, nextIndent, indent)
                DebugString("BodyParams: \(debug)\n", &buffer, indent, nextIndent, indent)
            }
            if let uploadItems = self.uploadItems {
                let debug = uploadItems.debugString(0, nextIndent, indent)
                DebugString("UploadItems: \(debug)\n", &buffer, indent, nextIndent, indent)
            }
        }
        if self.timeout > TimeInterval.leastNonzeroMagnitude {
            let debug = self.timeout.debugString(0, nextIndent, indent)
            DebugString("Timeout: \(debug)\n", &buffer, indent, nextIndent, indent)
        }
        if self.retries > TimeInterval.leastNonzeroMagnitude {
            let debug = self.retries.debugString(0, nextIndent, indent)
            DebugString("Retries: \(debug)\n", &buffer, indent, nextIndent, indent)
        }
        if self.delay > TimeInterval.leastNonzeroMagnitude {
            let debug = self.delay.debugString(0, nextIndent, indent)
            DebugString("Delay: \(debug)\n", &buffer, indent, nextIndent, indent)
        }

        if footerIndent > 0 {
            buffer.append(String(repeating: "\t", count: footerIndent))
        }
        buffer.append(">")
    }
    
}

extension ApiRequest.UploadItem : IDebug {

    public func debugString(_ buffer: inout String, _ headerIndent: Int, _ indent: Int, _ footerIndent: Int) {
        let nextIndent = indent + 1

        if headerIndent > 0 {
            buffer.append(String(repeating: "\t", count: headerIndent))
        }
        buffer.append("<\(String(describing: self))\n")

        DebugString("Name: \(self.name)\n", &buffer, indent, nextIndent, indent)
        if let filename = self.filename {
            DebugString("Filename: \(filename)\n", &buffer, indent, nextIndent, indent)
        }
        if let mimetype = self.mimetype {
            DebugString("Mimetype: \(mimetype)\n", &buffer, indent, nextIndent, indent)
        }
        DebugString("Data: \(self.data)\n", &buffer, indent, nextIndent, indent)

        if footerIndent > 0 {
            buffer.append(String(repeating: "\t", count: footerIndent))
        }
        buffer.append(">")
    }
    
}

#endif
