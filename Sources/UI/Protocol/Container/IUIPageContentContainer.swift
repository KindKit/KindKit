//
//  KindKit
//

import Foundation

public protocol IUIPageContentContainer : IUIContainer, IUIContainerParentable {
    
    var pageContainer: IUIPageContainer? { get }
    
    var pageItemView: UI.View.PageBar.Item { get }
    
}

public extension IUIPageContentContainer {
    
    @inlinable
    var pageContainer: IUIPageContainer? {
        return self.parent as? IUIPageContainer
    }
    
    @inlinable
    func updatePageBar(animated: Bool, completion: (() -> Void)? = nil) {
        guard let pageContainer = self.pageContainer else {
            completion?()
            return
        }
        pageContainer.updateBar(animated: animated, completion: completion)
    }
    
}
