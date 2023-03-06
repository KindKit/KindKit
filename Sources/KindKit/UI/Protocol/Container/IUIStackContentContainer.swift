//
//  KindKit
//

import Foundation

public protocol IUIStackContentContainer : IUIContainer, IUIContainerParentable {
    
    var stackContainer: IUIStackContainer? { get }
    
    var stackBar: UI.View.StackBar { get }
    var stackBarVisibility: Double { get }
    var stackBarHidden: Bool { get }
    
}

public extension IUIStackContentContainer {
    
    @inlinable
    var stackContainer: IUIStackContainer? {
        return self.parent as? IUIStackContainer
    }
    
    @inlinable
    @discardableResult
    func pop(animated: Bool = true, completion: (() -> Void)? = nil) -> Bool {
        guard let container = self.stackContainer else { return false }
        container.pop(animated: animated, completion: completion)
        return true
    }
    
    @inlinable
    @discardableResult
    func popToRoot(animated: Bool = true, completion: (() -> Void)? = nil) -> Bool {
        guard let container = self.stackContainer else { return false }
        container.popToRoot(animated: animated, completion: completion)
        return true
    }
    
}
