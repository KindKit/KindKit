//
//  KindKit
//

import Foundation

public protocol IUIScreenStackable : AnyObject {
    
    var stackBar: UI.View.StackBar { get }
    var stackBarVisibility: Float { get }
    var stackBarHidden: Bool { get }
    
}

public extension IUIScreenStackable {
    
    var stackBarVisibility: Float {
        return 1
    }
    
    var stackBarHidden: Bool {
        return false
    }
    
}

public extension IUIScreenStackable where Self : IUIScreen {
    
    @inlinable
    var stackContentContainer: IUIStackContentContainer? {
        guard let contentContainer = self.container as? IUIStackContentContainer else { return nil }
        return contentContainer
    }
    
    @inlinable
    var stackContainer: IUIStackContainer? {
        return self.stackContentContainer?.stackContainer
    }
    
    @discardableResult
    func stackUpdate(animated: Bool, completion: (() -> Void)? = nil) -> Bool {
        guard let contentContainer = self.stackContentContainer else { return false }
        guard let container = contentContainer.stackContainer else { return false }
        container.update(container: contentContainer, animated: animated, completion: completion)
        return true
    }
    
    @discardableResult
    func stackPop(animated: Bool = true, completion: (() -> Void)? = nil) -> Bool {
        guard let container = self.stackContainer else { return false }
        container.pop(animated: animated, completion: completion)
        return true
    }
    
    @discardableResult
    func stackPopToRoot(animated: Bool = true, completion: (() -> Void)? = nil) -> Bool {
        guard let container = self.stackContainer else { return false }
        container.popToRoot(animated: animated, completion: completion)
        return true
    }
    
}
