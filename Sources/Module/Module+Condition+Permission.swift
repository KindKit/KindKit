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
