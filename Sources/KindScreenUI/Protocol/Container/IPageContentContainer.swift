//
//  KindKit
//

import KindUI

public protocol IPageContentContainer : IContainer, IContainerParentable {
    
    var pageContainer: IPageContainer? { get }
    
    var pageItem: PageBarView.Item { get }
    
}

public extension IPageContentContainer {
    
    @inlinable
    var pageContainer: IPageContainer? {
        return self.parent as? IPageContainer
    }
    
    @inlinable
    @discardableResult
    func updateBar(animated: Bool, completion: (() -> Void)? = nil) -> Bool {
        guard let container = self.pageContainer else { return false }
        container.updateBar(animated: animated, completion: completion)
        return true
    }
    
    @inlinable
    @discardableResult
    func updateItem(animated: Bool, completion: (() -> Void)? = nil) -> Bool {
        guard let container = self.pageContainer else { return false }
        container.update(container: self, animated: animated, completion: completion)
        return true
    }
    
}
