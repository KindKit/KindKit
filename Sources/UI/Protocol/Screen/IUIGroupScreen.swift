//
//  KindKit
//

import Foundation

public protocol IUIGroupScreen : IUIScreen {
    
    var groupBarView: UI.View.GroupBar { get }
    var groupBarVisibility: Float { get }
    var groupBarHidden: Bool { get }
    
}

public extension IUIGroupScreen {
    
    @inlinable
    var groupContainer: IUIGroupContainer? {
        return self.container as? IUIGroupContainer
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
