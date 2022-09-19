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
