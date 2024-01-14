//
//  KindKit
//

import KindCondition

public protocol ICallToAction {
    
    var condition: KindCondition.IEntity { get }
    var dependencies: [ICallToAction] { get }
    
    func show()
    
}

public extension ICallToAction {
    
    @inlinable
    var canShow: Bool {
        return self.condition()
    }
    
}
