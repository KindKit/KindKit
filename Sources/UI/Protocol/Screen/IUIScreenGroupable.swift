//
//  KindKit
//

import Foundation

public protocol IUIScreenGroupable : AnyObject {
    
    var groupItem: UI.View.GroupBar.Item { get }
    
}

public extension IUIScreenGroupable where Self : IUIScreen {
    
    @inlinable
    var groupContentContainer: IUIGroupContentContainer? {
        guard let contentContainer = self.container as? IUIGroupContentContainer else { return nil }
        return contentContainer
    }
    
    @inlinable
    var groupContainer: IUIGroupContainer? {
        return self.groupContentContainer?.groupContainer
    }
    
}
