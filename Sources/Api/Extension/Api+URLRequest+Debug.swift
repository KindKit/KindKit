//
//  KindKit
//

import Foundation

#if DEBUG

extension URLRequest : IDebug {
    
    public func debugString(_ buffer: inout String, _ headerIndent: Int, _ indent: Int, _ footerIndent: Int) {
        let nextIndent = indent + 1

        if headerIndent > 0 {
            buffer.append(String(repeating: "\t", count: headerIndent))
        }
        buffer.append("<\(String(describing: self))\n")

        if let url = self.url {
            let debug = url.debugString(0, nextIndent, indent)
            DebugString("URL: \(debug)\n", &buffer, indent, nextIndent, indent)
        }
        if let method = self.httpMethod {
            let debug = method.debugString(0, nextIndent, indent)
            DebugString("Method: \(debug)\n", &buffer, indent, nextIndent, indent)
        }
        if let headers = self.allHTTPHeaderFields {
            if headers.isEmpty == false {
                let debug = headers.debugString(0, nextIndent, indent)
                DebugString("Headers: \(debug)\n", &buffer, indent, nextIndent, indent)
            }
        }
        switch self.cachePolicy {
        case .useProtocolCachePolicy:
            DebugString("CachePolicy: UseProtocolCachePolicy\n", &buffer, indent, nextIndent, indent)
        case .reloadIgnoringLocalCacheData:
            DebugString("CachePolicy: ReloadIgnoringLocalCacheData\n", &buffer, indent, nextIndent, indent)
        case .reloadIgnoringLocalAndRemoteCacheData:
            DebugString("CachePolicy: ReloadIgnoringLocalAndRemoteCacheData\n", &buffer, indent, nextIndent, indent)
        case .returnCacheDataElseLoad:
            DebugString("CachePolicy: ReturnCacheDataElseLoad\n", &buffer, indent, nextIndent, indent)
        case .returnCacheDataDontLoad:
            DebugString("CachePolicy: ReturnCacheDataDontLoad\n", &buffer, indent, nextIndent, indent)
        case .reloadRevalidatingCacheData:
            DebugString("CachePolicy: ReloadRevalidatingCacheData\n", &buffer, indent, nextIndent, indent)
        @unknown default:
            break
        }
        if let body = self.httpBody {
            if body.isEmpty == false {
                var debug = String()
                if let json = try? JSONSerialization.jsonObject(with: body) {
                    if let array = json as? NSArray {
                        array.debugString(&debug, 0, nextIndent, indent)
                    } else if let dictionay = json as? NSDictionary {
                        dictionay.debugString(&debug, 0, nextIndent, indent)
                    }
                } else if let string = String(data: body, encoding: .utf8) {
                    string.debugString(&debug, 0, nextIndent, indent)
                } else {
                    body.debugString(&debug, 0, nextIndent, indent)
                }
                DebugString("Body: \(debug)\n", &buffer, indent, nextIndent, indent)
            }
        }

        if footerIndent > 0 {
            buffer.append(String(repeating: "\t", count: footerIndent))
        }
        buffer.append(">")
    }
    
}

#endif
