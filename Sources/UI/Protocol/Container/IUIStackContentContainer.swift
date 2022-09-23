//
//  KindKit
//

import Foundation

public protocol IUIStackContentContainer : IUIContainer, IUIContainerParentable {
    
    var stackContainer: IUIStackContainer? { get }
    
    var stackBar: UI.View.StackBar { get }
    var stackBarVisibility: Float { get }
    var stackBarHidden: Bool { get }
    
}

public extension IUIStackContentContainer {
    
    @inlinable
    var stackContainer: IUIStackContainer? {
        return self.parent as? IUIStackContainer
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
