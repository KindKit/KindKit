//
//  KindKit
//

import KindUI

public protocol IScreenGroupable : AnyObject {
    
    var groupItem: GroupBarView.Item { get }
    
}

public extension IScreenGroupable where Self : IScreen {
    
    @inlinable
    var groupContentContainer: IGroupContentContainer? {
        guard let contentContainer = self.container as? IGroupContentContainer else { return nil }
        return contentContainer
    }
    
    @inlinable
    var groupContainer: IGroupContainer? {
        return self.groupContentContainer?.groupContainer
    }
    
    @inlinable
    @discardableResult
    func pageUpdate(animated: Bool, completion: (() -> Void)? = nil) -> Bool {
        guard let container = self.groupContentContainer else { return false }
        return container.updateItem(animated: animated, completion: completion)
    }
    
}
