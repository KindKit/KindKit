//
//  KindKitApi
//

import Foundation
import KindKitCore

open class ApiResponse : IApiResponse {

    public private(set) var url: URL?
    public private(set) var mimeType: String?
    public private(set) var textEncodingName: String?
    public private(set) var httpStatusCode: Int?
    public private(set) var httpHeaders: [AnyHashable: Any]?
    public var error: Error?

    public init() {
    }

    public func parse(response: URLResponse, data: Data?) {
        self.url = response.url
        self.mimeType = response.mimeType
        self.textEncodingName = response.textEncodingName
        if let httpResponse = response as? HTTPURLResponse {
            self.httpStatusCode = httpResponse.statusCode
            self.httpHeaders = httpResponse.allHeaderFields
        }
        do {
            if let data = data {
                try self.parse(data: data)
            } else {
                try self.parse()
            }
        } catch let error {
            self.parse(error: error)
        }
    }
    
    open func parse() throws {
    }

    open func parse(data: Data) throws {
        throw ApiError.invalidResponse
    }

    open func parse(error: Error) {
        self.error = error
    }

    open func reset() {
        self.url = nil
        self.mimeType = nil
        self.textEncodingName = nil
        self.httpStatusCode = nil
        self.httpHeaders = nil
        self.error = nil
    }

}

#if DEBUG

extension ApiResponse : IDebug {

    open func debugString(_ buffer: inout String, _ headerIndent: Int, _ indent: Int, _ footerIndent: Int) {
        let nextIndent = indent + 1

        if headerIndent > 0 {
            buffer.append(String(repeating: "\t", count: headerIndent))
        }
        buffer.append("<\(String(describing: self))\n")

        if let url = self.url {
            let debug = url.debugString(0, nextIndent, indent)
            DebugString("Url: \(debug)\n", &buffer, indent, nextIndent, indent)
        }
        if let mimeType = self.mimeType {
            let debug = mimeType.debugString(0, nextIndent, indent)
            DebugString("MimeType: \(debug)\n", &buffer, indent, nextIndent, indent)
        }
        if let textEncodingName = self.textEncodingName {
            let debug = textEncodingName.debugString(0, nextIndent, indent)
            DebugString("TextEncodingName: \(debug)\n", &buffer, indent, nextIndent, indent)
        }
        if let httpStatusCode = self.httpStatusCode {
            let debug = httpStatusCode.debugString(0, nextIndent, indent)
            DebugString("HttpStatusCode: \(debug)\n", &buffer, indent, nextIndent, indent)
        }
        if let httpHeaders = self.httpHeaders {
            let debug = httpHeaders.debugString(0, nextIndent, indent)
            DebugString("HttpHeaders: \(debug)\n", &buffer, indent, nextIndent, indent)
        }
        if let error = self.error as IDebug? {
            let debug = error.debugString(0, nextIndent, indent)
            DebugString("Error: \(debug)\n", &buffer, indent, nextIndent, indent)
        }

        if footerIndent > 0 {
            buffer.append(String(repeating: "\t", count: footerIndent))
        }
        buffer.append(">")
    }
    
}

#endif
