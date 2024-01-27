//
//  KindKit
//

import KindUI

public protocol IGroupContentContainer : IContainer, IContainerParentable {
    
    var groupContainer: IGroupContainer? { get }
    
    var groupItem: GroupBarView.Item { get }
    
}

public extension IGroupContentContainer {
    
    @inlinable
    var groupContainer: IGroupContainer? {
        return self.parent as? IGroupContainer
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
