//
//  KindKit
//

import Foundation

public extension Module.Condition {

    final class Not : IModuleCondition {
        
        public var state: Bool {
            return !self._condition.state
        }
        
        private var _condition: IModuleCondition
        
        public init(_ condition: IModuleCondition) {
            self._condition = condition
        }
        
    }

}

public extension IModuleCondition where Self == Module.Condition.Not {
    
    @inlinable
    static func not(
        _ condition: IModuleCondition
    ) -> Self {
        return .init(condition)
    }
    
}
