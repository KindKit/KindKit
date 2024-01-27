//
//  KindKit
//

import Foundation

extension NSError : DebugTrait {
    
    public func buildInfo() -> Info {
        return ObjectInfo(name: "NSError", sequenceBuilder: {
            KeyValueInfo(
                key: StringInfo("Domain"),
                value: StringInfo(self.domain)
            )
            KeyValueInfo(
                key: StringInfo("Code"),
                value: self.code
            )
            KeyValueInfo(
                key: StringInfo("UserInfo"),
                value: self.userInfo
            )
        })
    }

}
