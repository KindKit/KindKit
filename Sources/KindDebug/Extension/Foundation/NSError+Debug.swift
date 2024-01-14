//
//  KindKit
//

import Foundation

extension NSError : IEntity {
    
    public func debugInfo() -> Info {
        return .object(name: "NSError", sequence: { items in
            items.append(.pair(string: "Domain", cast: self.domain))
            items.append(.pair(string: "Code", cast: self.code))
            items.append(.pair(string: "UserInfo", cast: self.userInfo))
        })
    }

}
