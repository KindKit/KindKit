//
//  KindKit
//

import Foundation

@available(*, deprecated, renamed: "IScreenGroupable")
public typealias IUIScreenGroupable = IScreenGroupable

public protocol IScreenGroupable : AnyObject {
    
    var groupItem: UI.View.GroupBar.Item { get }
    
}

public extension IScreenGroupable where Self : IScreen {
    
    @inlinable
    var groupContentContainer: IUIGroupContentContainer? {
        guard let contentContainer = self.container as? IUIGroupContentContainer else { return nil }
        return contentContainer
    }
    
    @inlinable
    var groupContainer: IUIGroupContainer? {
        return self.groupContentContainer?.groupContainer
    }
    
    @inlinable
    @discardableResult
    func pageUpdate(animated: Bool, completion: (() -> Void)? = nil) -> Bool {
        guard let container = self.groupContentContainer else { return false }
        return container.updateItem(animated: animated, completion: completion)
    }
    
}
