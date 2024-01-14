//
//  KindKit
//

import KindPermission

public typealias Permission = KindPermission.Entity< PermissionRequest >

public extension KindPermission.Entity where RequestType : PermissionRequest {
    
    convenience init(preferedWhen: PermissionRequest.When) {
        self.init(.init(preferedWhen: preferedWhen))
    }
    
}
