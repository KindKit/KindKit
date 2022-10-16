//
//  KindKit
//

import Foundation

public protocol IUIPageContentContainer : IUIContainer, IUIContainerParentable {
    
    var pageContainer: IUIPageContainer? { get }
    
    var pageItem: UI.View.PageBar.Item { get }
    
}

public extension IUIPageContentContainer {
    
    @inlinable
    var pageContainer: IUIPageContainer? {
        return self.parent as? IUIPageContainer
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
