//
//  KindKit
//

import Foundation

public protocol IModuleCallToAction {
    
    var condition: ICondition { get }
    var dependencies: [IModuleCallToAction] { get }
    
    func show()
    
}

public extension IModuleCallToAction {
    
    @inlinable
    var canShow: Bool {
        return self.condition()
    }
    
}
