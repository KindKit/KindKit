//
//  KindKitView
//

import Foundation
import KindKitCore

public protocol IGroupScreen : IScreen {
    
    associatedtype GroupBar : IGroupBarView
    
    var groupBarView: GroupBar { get }
    var groupBarVisibility: Float { get }
    var groupBarHidden: Bool { get }
    
}

public extension IGroupScreen {
    
    @inlinable
    var groupContainer: IGroupContainer? {
        return self.container as? IGroupContainer
    }
    
    var groupBarVisibility: Float {
        return 1
    }
    
    var groupBarHidden: Bool {
        return false
    }
    
    func updateGroupBar(animated: Bool, completion: (() -> Void)? = nil) {
        guard let groupContainer = self.groupContainer else {
            completion?()
            return
        }
        groupContainer.updateBar(animated: animated, completion: completion)
    }
    
}
