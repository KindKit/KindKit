//
//  KindKit
//

import Foundation

extension URLRequest : IDebug {
    
    public func debugInfo() -> Debug.Info {
        return .object(name: "URLRequest", sequence: { items in
            if let value = self.url {
                items.append(.pair(string: "URL", cast: value))
            }
            if let value = self.httpMethod {
                items.append(.pair(string: "Method", cast: value))
            }
            if let value = self.allHTTPHeaderFields {
                if value.isEmpty == false {
                    items.append(.pair(string: "Headers", cast: value))
                }
            }
            switch self.cachePolicy {
            case .useProtocolCachePolicy:
                items.append(.pair(string: "CachePolicy", string: "UseProtocolCachePolicy"))
            case .reloadIgnoringLocalCacheData:
                items.append(.pair(string: "CachePolicy", string: "ReloadIgnoringLocalCacheData"))
            case .reloadIgnoringLocalAndRemoteCacheData:
                items.append(.pair(string: "CachePolicy", string: "ReloadIgnoringLocalAndRemoteCacheData"))
            case .returnCacheDataElseLoad:
                items.append(.pair(string: "CachePolicy", string: "ReturnCacheDataElseLoad"))
            case .returnCacheDataDontLoad:
                items.append(.pair(string: "CachePolicy", string: "ReturnCacheDataDontLoad"))
            case .reloadRevalidatingCacheData:
                items.append(.pair(string: "CachePolicy", string: "ReloadRevalidatingCacheData"))
            @unknown default:
                break
            }
            if let body = self.httpBody {
                if body.isEmpty == false {
                    items.append(.pair(string: "Body", cast: body))
                }
            }
        })
    }
    
}
