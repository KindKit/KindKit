//
//  KindKitView
//

import Foundation
import KindKitCore
import KindKitMath

public protocol IScreenGroupable : AnyObject {
    
    associatedtype AssociatedGroupItemView : IBarItemView
    
    var groupItemView: AssociatedGroupItemView { get }
    
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
    
}
