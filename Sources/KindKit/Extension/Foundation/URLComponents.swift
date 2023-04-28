//
//  KindKit
//

import Foundation

public extension URLComponents {
    
    func kk_queryItem(by name: String) -> URLQueryItem? {
        guard let queryItems = self.queryItems else { return nil }
        return queryItems.first(where: { return $0.name == name })
    }
    
}

extension URLComponents : IDebug {
    
    public func dump(_ buff: StringBuilder, _ indent: Debug.Indent) {
        if let scheme = self.scheme {
            buff.append(inter: indent, key: "Sheme", value: scheme)
        }
        if let user = self.user {
            buff.append(inter: indent, key: "User", value: user)
        }
        if let password = self.password {
            buff.append(inter: indent, key: "Password", value: password)
        }
        if let host = self.host {
            buff.append(inter: indent, key: "Host", value: host)
        }
        if let port = self.port {
            buff.append(inter: indent, key: "Port", value: port)
        }
        do {
            buff.append(inter: indent, key: "Path", value: self.path)
        }
        if let query = self.query {
            buff.append(inter: indent, key: "Query", value: query)
        }
        if let fragment = self.fragment {
            buff.append(inter: indent, key: "Fragment", value: fragment)
        }
    }
    
}
