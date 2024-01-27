//
//  KindKit
//

import KindUI

public protocol IStackContentContainer : IContainer, IContainerParentable {
    
    var stackContainer: IStackContainer? { get }
    
    var stackBar: StackBarView { get }
    var stackBarVisibility: Double { get }
    var stackBarHidden: Bool { get }
    
}

public extension IStackContentContainer {
    
    @inlinable
    var stackContainer: IStackContainer? {
        return self.parent as? IStackContainer
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
