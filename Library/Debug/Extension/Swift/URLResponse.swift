//
//  KindKit
//

import Foundation

extension URLResponse : DebugTrait {
    
    public func buildInfo() -> Info {
        return ObjectInfo(name: "URLResponse", sequenceBuilder: {
            if let value = self.url {
                KeyValueInfo(
                    key: StringInfo("URL"),
                    value: value
                )
            }
            if let value = self.mimeType {
                KeyValueInfo(
                    key: StringInfo("MimeType"),
                    value: value
                )
            }
            if let value = self.textEncodingName {
                KeyValueInfo(
                    key: StringInfo("TextEncoding"),
                    value: value
                )
            }
            if let http = self as? HTTPURLResponse {
                KeyValueInfo(
                    key: StringInfo("StatusCode"),
                    value: http.statusCode
                )
                if http.allHeaderFields.isEmpty == false {
                    KeyValueInfo(
                        key: StringInfo("Headers"),
                        value: http.allHeaderFields
                    )
                }
            }
        })
    }
    
}
