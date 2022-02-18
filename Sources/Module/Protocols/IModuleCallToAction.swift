//
//  KindKitModule
//

import Foundation
import KindKitCore

public protocol IModuleCallToAction {
    
    var condition: IModuleCondition { get }
    var dependencies: [IModuleCallToAction] { get }
    
    func show()
    
}

public extension IModuleCallToAction {
    
    @inlinable
    var canShow: Bool {
        return self.condition.state
    }
    
}
