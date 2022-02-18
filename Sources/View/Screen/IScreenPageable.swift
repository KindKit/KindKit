//
//  KindKitView
//

import Foundation
import KindKitCore
import KindKitMath

public protocol IScreenPageable : AnyObject {
    
    associatedtype PageItemView : IBarItemView
    
    var pageItemView: PageItemView { get }
    
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
