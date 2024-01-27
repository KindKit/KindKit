//
//  KindKit
//

import Foundation

extension URLRequest : DebugTrait {
    
    public func buildInfo() -> Info {
        return ObjectInfo(name: "URLRequest", sequenceBuilder: {
            if let value = self.url {
                KeyValueInfo(
                    key: StringInfo("URL"),
                    value: value
                )
            }
            if let value = self.httpMethod {
                KeyValueInfo(
                    key: StringInfo("Method"),
                    value: value
                )
            }
            if let value = self.allHTTPHeaderFields {
                if value.isEmpty == false {
                    KeyValueInfo(
                        key: StringInfo("Headers"),
                        value: value
                    )
                }
            }
            switch self.cachePolicy {
            case .useProtocolCachePolicy:
                KeyValueInfo(
                    key: StringInfo("CachePolicy"),
                    value: StringInfo("UseProtocolCachePolicy")
                )
            case .reloadIgnoringLocalCacheData:
                KeyValueInfo(
                    key: StringInfo("CachePolicy"),
                    value: StringInfo("ReloadIgnoringLocalCacheData")
                )
            case .reloadIgnoringLocalAndRemoteCacheData:
                KeyValueInfo(
                    key: StringInfo("CachePolicy"),
                    value: StringInfo("ReloadIgnoringLocalAndRemoteCacheData")
                )
            case .returnCacheDataElseLoad:
                KeyValueInfo(
                    key: StringInfo("CachePolicy"),
                    value: StringInfo("ReturnCacheDataElseLoad")
                )
            case .returnCacheDataDontLoad:
                KeyValueInfo(
                    key: StringInfo("CachePolicy"),
                    value: StringInfo("ReturnCacheDataDontLoad")
                )
            case .reloadRevalidatingCacheData:
                KeyValueInfo(
                    key: StringInfo("CachePolicy"),
                    value: StringInfo("ReloadRevalidatingCacheData")
                )
            @unknown default:
                EmptyInfo()
            }
            if let body = self.httpBody {
                if body.isEmpty == false {
                    KeyValueInfo(
                        key: StringInfo("Body"),
                        value: body
                    )
                }
            }
        })
    }
    
}
