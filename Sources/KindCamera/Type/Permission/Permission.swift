//
//  KindKit
//

import KindPermission

public typealias Permission = KindPermission.Entity< PermissionRequest >

public extension KindPermission.Entity where RequestType : PermissionRequest {
    
    convenience init() {
        self.init(.init())
    }
    
}
