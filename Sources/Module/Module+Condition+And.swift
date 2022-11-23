//
//  KindKit
//

import Foundation

public extension Module.Condition {

    final class And : IModuleCondition {
        
        public var state: Bool {
            guard self._conditions.isEmpty == false else {
                return false
            }
            for condition in self._conditions {
                if condition.state == false {
                    return false
                }
            }
            return true
        }
        
        private var _conditions: [IModuleCondition]
        
        public init(
            _ conditions: [IModuleCondition]
        ) {
            self._conditions = conditions
        }
        
    }

}

public extension IModuleCondition where Self == Module.Condition.And {
    
    @inlinable
    static func and(
        _ conditions: [IModuleCondition]
    ) -> Self {
        return .init(conditions)
    }
    
}
