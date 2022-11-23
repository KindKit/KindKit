//
//  KindKit
//

import Foundation

public extension Module.Condition {

    final class Permission : IModuleCondition {
        
        public var state: Bool {
            return self._states.contains(self._permission.status)
        }
        
        private var _permission: IPermission
        private var _states: [KindKit.Permission.Status]
        
        public init(_ permission: IPermission, states: [KindKit.Permission.Status]) {
            self._permission = permission
            self._states = states
        }
        
    }

}

public extension IModuleCondition where Self == Module.Condition.Permission {
    
    @inlinable
    static func permission(
        _ permission: IPermission,
        states: [KindKit.Permission.Status]
    ) -> Self {
        return .init(permission, states: states)
    }
    
}
