//
//  KindKit
//

import Foundation

public extension Module.Condition {

    final class Or : IModuleCondition {
        
        public var state: Bool {
            for condition in self._conditions {
                if condition.state == true {
                    return true
                }
            }
            return false
        }
        
        private var _conditions: [IModuleCondition]
        
        public init(_ conditions: [IModuleCondition]) {
            self._conditions = conditions
        }
        
    }

}

public extension IModuleCondition where Self == Module.Condition.Or {
    
    @inlinable
    static func or(
        _ conditions: [IModuleCondition]
    ) -> Self {
        return .init(conditions)
    }
    
}
