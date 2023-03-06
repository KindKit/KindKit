//
//  KindKit
//

import Foundation

public extension Module.Condition {

    final class Block : IModuleCondition {
        
        public var state: Bool {
            return self._block()
        }
        
        private let _block: () -> Bool
        
        public init(_ block: @escaping () -> Bool) {
            self._block = block
        }
        
    }

}

public extension IModuleCondition where Self == Module.Condition.Block {
    
    @inlinable
    static func block(
        _ block: @escaping () -> Bool
    ) -> Self {
        return .init(block)
    }
    
}
