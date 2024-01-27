//
//  KindKit
//

import KindUI

public protocol IGroupScreen : IScreen {
    
    var groupBar: GroupBarView { get }
    var groupBarVisibility: Double { get }
    var groupBarHidden: Bool { get }
    
    func change(current: IGroupContentContainer)
    
}

public extension IGroupScreen {
    
    var groupBarVisibility: Double {
        return 1
    }
    
    var groupBarHidden: Bool {
        return false
    }
    
    func change(current: IGroupContentContainer) {
    }
    
}

public extension IGroupScreen {
    
    @inlinable
    var groupContainer: IGroupContainer? {
        return self.container as? IGroupContainer
    }
    
    @discardableResult
    func update(animated: Bool, completion: (() -> Void)? = nil) -> Bool {
        guard let container = self.groupContainer else { return false }
        container.updateBar(animated: animated, completion: completion)
        return true
    }
    
}
