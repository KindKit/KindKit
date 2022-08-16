//
//  KindKitApi
//

import Foundation
import KindKitCore

#if DEBUG

extension URLResponse : IDebug {
    
    public func debugString(_ buffer: inout String, _ headerIndent: Int, _ indent: Int, _ footerIndent: Int) {
        let nextIndent = indent + 1

        if headerIndent > 0 {
            buffer.append(String(repeating: "\t", count: headerIndent))
        }
        buffer.append("<\(String(describing: self.classForCoder))\n")

        if let url = self.url {
            let debug = url.debugString(0, nextIndent, indent)
            DebugString("URL: \(debug)\n", &buffer, indent, nextIndent, indent)
        }
        if let mimeType = self.mimeType {
            let debug = mimeType.debugString(0, nextIndent, indent)
            DebugString("MimeType: \(debug)\n", &buffer, indent, nextIndent, indent)
        }
        if let textEncoding = self.textEncodingName {
            let debug = textEncoding.debugString(0, nextIndent, indent)
            DebugString("TextEncoding: \(debug)\n", &buffer, indent, nextIndent, indent)
        }
        if let http = self as? HTTPURLResponse {
            DebugString("StatusCode: \(http.statusCode)\n", &buffer, indent, nextIndent, indent)
            if http.allHeaderFields.isEmpty == false {
                let debug = http.allHeaderFields.debugString(0, nextIndent, indent)
                DebugString("Headers: \(debug)\n", &buffer, indent, nextIndent, indent)
            }
        }

        if footerIndent > 0 {
            buffer.append(String(repeating: "\t", count: footerIndent))
        }
        buffer.append(">")
    }
    
}

#endif
