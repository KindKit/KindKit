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
