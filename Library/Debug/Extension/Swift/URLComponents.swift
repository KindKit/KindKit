//
//  KindKit
//

import Foundation

extension URLComponents : DebugTrait {
    
    public func buildInfo() -> Info {
        return ObjectInfo(name: "URLComponents", sequenceBuilder: {
            if let value = self.scheme {
                KeyValueInfo(
                    key: StringInfo("Sheme"),
                    value: value
                )
            }
            if let value = self.user {
                KeyValueInfo(
                    key: StringInfo("User"),
                    value: value
                )
            }
            if let value = self.password {
                KeyValueInfo(
                    key: StringInfo("Password"),
                    value: value
                )
            }
            if let value = self.host {
                KeyValueInfo(
                    key: StringInfo("Host"),
                    value: value
                )
            }
            if let value = self.port {
                KeyValueInfo(
                    key: StringInfo("Port"),
                    value: value
                )
            }
            do {
                KeyValueInfo(
                    key: StringInfo("Path"),
                    value: self.path
                )
            }
            if let value = self.query {
                KeyValueInfo(
                    key: StringInfo("Query"),
                    value: value
                )
            }
            if let value = self.fragment {
                KeyValueInfo(
                    key: StringInfo("Fragment"),
                    value: value
                )
            }
        })
    }
    
}
