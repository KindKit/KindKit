//
//  KindKitModule
//

import Foundation
import KindKitCore
import KindKitPermission

public final class ModulePermissionCondition : IModuleCondition {
    
    public var state: Bool {
        return self._states.contains(self._permission.status)
    }
    
    private var _permission: IPermission
    private var _states: [PermissionStatus]
    
    public init(_ permission: IPermission, states: [PermissionStatus]) {
        self._permission = permission
        self._states = states
    }
    
}
