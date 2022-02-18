//
//  KindKitModule
//

import Foundation
import KindKitCore

public protocol IModuleFeature {
    
    var condition: IModuleCondition { get }
    
}

public extension IModuleFeature {
    
    @inlinable
    var isEnabled: Bool {
        return self.condition.state
    }
    
}
