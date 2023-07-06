//
//  KindKit
//

import Foundation

@available(*, deprecated, renamed: "IScreenPageable")
public typealias IUIScreenPageable = IScreenPageable

public protocol IScreenPageable : AnyObject {
    
    var pageItem: UI.View.PageBar.Item { get }
    
}

public extension IScreenPageable where Self : IScreen {
    
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
    @discardableResult
    func pageUpdate(animated: Bool, completion: (() -> Void)? = nil) -> Bool {
        guard let container = self.pageContentContainer else { return false }
        return container.updateItem(animated: animated, completion: completion)
    }
    
}
