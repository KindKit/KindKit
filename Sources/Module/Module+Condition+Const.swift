//
//  KindKit
//

import Foundation

public extension Module.Condition {

    final class Const : IModuleCondition {
        
        public var state: Bool
        
        public init(_ state: Bool) {
            self.state = state
        }
        
    }

}

public extension IModuleCondition where Self == Module.Condition.Const {
    
    @inlinable
    static func const(
        _ state: Bool
    ) -> Self {
        return .init(state)
    }
    
}
