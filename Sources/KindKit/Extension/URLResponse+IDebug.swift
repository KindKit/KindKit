//
//  KindKit
//

import Foundation

extension URLResponse : IDebug {
    
    public func debugInfo() -> Debug.Info {
        return .object(name: "URLResponse", sequence: { items in
            if let value = self.url {
                items.append(.pair(string: "URL", cast: value))
            }
            if let value = self.mimeType {
                items.append(.pair(string: "MimeType", cast: value))
            }
            if let value = self.textEncodingName {
                items.append(.pair(string: "TextEncoding", cast: value))
            }
            if let http = self as? HTTPURLResponse {
                items.append(.pair(string: "StatusCode", cast: http.statusCode))
                if http.allHeaderFields.isEmpty == false {
                    items.append(.pair(string: "Headers", cast: http.allHeaderFields))
                }
            }
        })
    }
    
}
