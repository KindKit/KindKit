//
//  KindKit
//

import KindPermission

public typealias Permission = KindPermission.Entity< PermissionRequest >

public extension KindPermission.Entity where RequestType : PermissionRequest {
    
    var preferedWhen: PermissionRequest.When {
        return self.request.preferedWhen
    }
    
    var when: PermissionRequest.When? {
        return self.request.when
    }
    
    convenience init(preferedWhen: PermissionRequest.When) {
        self.init(.init(preferedWhen: preferedWhen))
    }
    
}
