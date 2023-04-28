//
//  KindKit
//

import Foundation

extension URLResponse : IDebug {
    
    public func dump(_ buff: StringBuilder, _ indent: Debug.Indent) {
        if let url = self.url {
            buff.append(inter: indent, key: "URL", value: url)
        }
        if let mimeType = self.mimeType {
            buff.append(inter: indent, key: "MimeType", value: mimeType)
        }
        if let textEncoding = self.textEncodingName {
            buff.append(inter: indent, key: "TextEncoding", value: textEncoding)
        }
        if let http = self as? HTTPURLResponse {
            buff.append(inter: indent, key: "StatusCode", value: http.statusCode)
            if http.allHeaderFields.isEmpty == false {
                buff.append(inter: indent, key: "Headers", value: http.allHeaderFields)
            }
        }
    }
    
}
