//
//  KindKit
//

import Foundation

extension URLComponents : IDebug {
    
    public func debugInfo() -> Debug.Info {
        return .object(name: "URLComponents", sequence: { items in
            if let value = self.scheme {
                items.append(.pair(string: "Sheme", cast: value))
            }
            if let value = self.user {
                items.append(.pair(string: "User", cast: value))
            }
            if let value = self.password {
                items.append(.pair(string: "Password", cast: value))
            }
            if let value = self.host {
                items.append(.pair(string: "Host", cast: value))
            }
            if let value = self.port {
                items.append(.pair(string: "Port", cast: value))
            }
            do {
                items.append(.pair(string: "Path", cast: self.path))
            }
            if let value = self.query {
                items.append(.pair(string: "Query", cast: value))
            }
            if let value = self.fragment {
                items.append(.pair(string: "Fragment", cast: value))
            }
        })
    }
    
}
