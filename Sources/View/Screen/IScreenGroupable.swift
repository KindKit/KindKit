//
//  KindKitView
//

import Foundation
import KindKitCore
import KindKitMath

public protocol IScreenGroupable : AnyObject {
    
    associatedtype GroupItemView : IBarItemView
    
    var groupItemView: GroupItemView { get }
    
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
