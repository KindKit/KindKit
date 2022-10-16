//
//  KindKit
//

import Foundation

public protocol IUIGroupContentContainer : IUIContainer, IUIContainerParentable {
    
    var groupContainer: IUIGroupContainer? { get }
    
    var groupItem: UI.View.GroupBar.Item { get }
    
}

public extension IUIGroupContentContainer {
    
    @inlinable
    var groupContainer: IUIGroupContainer? {
        return self.parent as? IUIGroupContainer
    }
    
    @inlinable
    @discardableResult
    func updateBar(animated: Bool, completion: (() -> Void)? = nil) -> Bool {
        guard let container = self.groupContainer else { return false }
        container.updateBar(animated: animated, completion: completion)
        return true
    }
    
    @inlinable
    @discardableResult
    func updateItem(animated: Bool, completion: (() -> Void)? = nil) -> Bool {
        guard let container = self.groupContainer else { return false }
        container.update(container: self, animated: animated, completion: completion)
        return true
    }
    
}
