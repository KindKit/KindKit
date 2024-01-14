//
//  KindKit
//

import KindUI

public protocol IScreenPageable : AnyObject {
    
    var pageItem: PageBarView.Item { get }
    
}

public extension IScreenPageable where Self : IScreen {
    
    @inlinable
    var pageContentContainer: IPageContentContainer? {
        guard let contentContainer = self.container as? IPageContentContainer else { return nil }
        return contentContainer
    }
    
    @inlinable
    var pageContainer: IPageContainer? {
        return self.pageContentContainer?.pageContainer
    }
    
    @inlinable
    @discardableResult
    func pageUpdate(animated: Bool, completion: (() -> Void)? = nil) -> Bool {
        guard let container = self.pageContentContainer else { return false }
        return container.updateItem(animated: animated, completion: completion)
    }
    
}
