//
//  KindKit
//

import KindPermission

public typealias Permission = KindPermission.Permission< PermissionRequest >

public extension KindPermission.Permission where Request : PermissionRequest {
    
    convenience init() {
        self.init(.init())
    }
    
}
