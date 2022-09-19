//
//  KindKit
//

import Foundation

public protocol IUIScreenStackable : AnyObject {
    
    var stackBarView: UI.View.StackBar { get }
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
    
    @inlinable
    func updateStack(animated: Bool, completion: (() -> Void)? = nil) {
        guard let contentContainer = self.stackContentContainer else {
            completion?()
            return
        }
        guard let container = contentContainer.stackContainer else {
            completion?()
            return
        }
        container.update(container: contentContainer, animated: animated, completion: completion)
    }
    
    @inlinable
    func pop(animated: Bool = true, completion: (() -> Void)? = nil) {
        guard let stackContainer = self.stackContainer else {
            completion?()
            return
        }
        stackContainer.pop(animated: animated, completion: completion)
    }
    
    @inlinable
    func popToRoot(animated: Bool = true, completion: (() -> Void)? = nil) {
        guard let stackContainer = self.stackContainer else {
            completion?()
            return
        }
        stackContainer.popToRoot(animated: animated, completion: completion)
    }
    
}
