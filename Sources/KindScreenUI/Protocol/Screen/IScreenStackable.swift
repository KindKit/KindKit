//
//  KindKit
//

import KindUI

public protocol IScreenStackable : AnyObject {
    
    var stackBar: StackBarView { get }
    var stackBarVisibility: Double { get }
    var stackBarHidden: Bool { get }
    
}

public extension IScreenStackable {
    
    var stackBarVisibility: Double {
        return 1
    }
    
    var stackBarHidden: Bool {
        return false
    }
    
}

public extension IScreenStackable where Self : IScreen {
    
    @inlinable
    var stackContentContainer: IStackContentContainer? {
        guard let contentContainer = self.container as? IStackContentContainer else { return nil }
        return contentContainer
    }
    
    @inlinable
    var stackContainer: IStackContainer? {
        return self.stackContentContainer?.stackContainer
    }
    
    @discardableResult
    func stackUpdate(animated: Bool, completion: (() -> Void)? = nil) -> Bool {
        guard let contentContainer = self.stackContentContainer else { return false }
        guard let container = contentContainer.stackContainer else { return false }
        container.update(container: contentContainer, animated: animated, completion: completion)
        return true
    }
    
}
