//
//  KindKitView
//

import Foundation
import KindKitCore
import KindKitMath

public protocol IScreenStackable : AnyObject {
    
    associatedtype StackBar : IStackBarView
    
    var stackBarView: StackBar { get }
    var stackBarVisibility: Float { get }
    var stackBarHidden: Bool { get }
    
}

public extension IScreenStackable {
    
    var stackBarVisibility: Float {
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
