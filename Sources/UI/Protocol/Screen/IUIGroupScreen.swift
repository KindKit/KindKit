//
//  KindKit
//

import Foundation

public protocol IUIGroupScreen : IUIScreen {
    
    var groupBar: UI.View.GroupBar { get }
    var groupBarVisibility: Float { get }
    var groupBarHidden: Bool { get }
    
    func change(current: IUIGroupContentContainer)
    
}

public extension IUIGroupScreen {
    
    var groupBarVisibility: Float {
        return 1
    }
    
    var groupBarHidden: Bool {
        return false
    }
    
    func change(current: IUIGroupContentContainer) {
    }
    
}

public extension IUIGroupScreen {
    
    @inlinable
    var groupContainer: IUIGroupContainer? {
        return self.container as? IUIGroupContainer
    }
    
    @discardableResult
    func update(animated: Bool, completion: (() -> Void)? = nil) -> Bool {
        guard let container = self.groupContainer else { return false }
        container.updateBar(animated: animated, completion: completion)
        return true
    }
    
}
