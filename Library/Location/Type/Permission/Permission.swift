//
//  KindKit
//

import KindPermission

public typealias Permission = KindPermission.Permission< PermissionRequest >

public extension KindPermission.Permission where Request : PermissionRequest {
    
    var preferedWhen: PermissionRequest.When {
        return self.data.preferedWhen
    }
    
    var when: PermissionRequest.When? {
        return self.data.when
    }
    
    convenience init(preferedWhen: PermissionRequest.When) {
        self.init(.init(preferedWhen: preferedWhen))
    }
    
}
