//
//  KindKit
//

import Foundation

@available(*, deprecated, renamed: "IGroupScreen")
public typealias IUIGroupScreen = IGroupScreen

public protocol IGroupScreen : IScreen {
    
    var groupBar: UI.View.GroupBar { get }
    var groupBarVisibility: Double { get }
    var groupBarHidden: Bool { get }
    
    func change(current: IUIGroupContentContainer)
    
}

public extension IGroupScreen {
    
    var groupBarVisibility: Double {
        return 1
    }
    
    var groupBarHidden: Bool {
        return false
    }
    
    func change(current: IUIGroupContentContainer) {
    }
    
}

public extension IGroupScreen {
    
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
