//
//  KindKit
//

import Foundation

public protocol IUIScreenPageable : AnyObject {
    
    var pageItem: UI.View.PageBar.Item { get }
    
}

public extension IUIScreenPageable where Self : IUIScreen {
    
    @inlinable
    var pageContentContainer: IUIPageContentContainer? {
        guard let contentContainer = self.container as? IUIPageContentContainer else { return nil }
        return contentContainer
    }
    
    @inlinable
    var pageContainer: IUIPageContainer? {
        return self.pageContentContainer?.pageContainer
    }
    
    @inlinable
    func updatePage(animated: Bool, completion: (() -> Void)? = nil) {
        guard let contentContainer = self.pageContentContainer else {
            completion?()
            return
        }
        guard let container = contentContainer.pageContainer else {
            completion?()
            return
        }
        container.update(container: contentContainer, animated: animated, completion: completion)
    }
    
}
