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
