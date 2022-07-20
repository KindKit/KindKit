//
//  KindKitModule
//

import Foundation
import KindKitCore

public final class ModuleConstCondition : IModuleCondition {
    
    public var state: Bool
    
    public init(_ state: Bool) {
        self.state = state
    }
    
}
