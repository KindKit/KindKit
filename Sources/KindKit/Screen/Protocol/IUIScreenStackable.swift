//
//  KindKit
//

import Foundation

@available(*, deprecated, renamed: "IScreenStackable")
public typealias IUIScreenStackable = IScreenStackable

public protocol IScreenStackable : AnyObject {
    
    var stackBar: UI.View.StackBar { get }
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
    
}
