//
//  KindKit
//

import Foundation

extension URLRequest : IDebug {
    
    public func dump(_ buff: StringBuilder, _ indent: Debug.Indent) {
        if let url = self.url {
            buff.append(inter: indent, key: "URL", value: url)
        }
        if let httpMethod = self.httpMethod {
            buff.append(inter: indent, key: "Method", value: httpMethod)
        }
        if let headers = self.allHTTPHeaderFields {
            if headers.isEmpty == false {
                buff.append(inter: indent, key: "Headers", value: headers)
            }
        }
        switch self.cachePolicy {
        case .useProtocolCachePolicy:
            buff.append(inter: indent, key: "CachePolicy", value: "UseProtocolCachePolicy")
        case .reloadIgnoringLocalCacheData:
            buff.append(inter: indent, key: "CachePolicy", value: "ReloadIgnoringLocalCacheData")
        case .reloadIgnoringLocalAndRemoteCacheData:
            buff.append(inter: indent, key: "CachePolicy", value: "ReloadIgnoringLocalAndRemoteCacheData")
        case .returnCacheDataElseLoad:
            buff.append(inter: indent, key: "CachePolicy", value: "ReturnCacheDataElseLoad")
        case .returnCacheDataDontLoad:
            buff.append(inter: indent, key: "CachePolicy", value: "ReturnCacheDataDontLoad")
        case .reloadRevalidatingCacheData:
            buff.append(inter: indent, key: "CachePolicy", value: "ReloadRevalidatingCacheData")
        @unknown default:
            break
        }
        if let body = self.httpBody {
            if body.isEmpty == false {
                if let json = try? JSONSerialization.jsonObject(with: body) {
                    if let root = json as? NSArray {
                        buff.append(
                            inter: indent,
                            key: "Body",
                            value: root
                        )
                    } else if let root = json as? NSDictionary {
                        buff.append(
                            inter: indent,
                            key: "Body",
                            value: root
                        )
                    }
                } else if let string = String(data: body, encoding: .utf8) {
                    buff.append(
                        inter: indent,
                        key: "Body",
                        value: string.kk_escape([ .tab, .return, .newline ])
                    )
                } else {
                    buff.append(
                        inter: indent,
                        key: "Body",
                        value: body
                    )
                }
            }
        }
    }
    
}
