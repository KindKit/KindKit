//
//  KindKit
//

import Foundation

public protocol IUIGroupContentContainer : IUIContainer, IUIContainerParentable {
    
    var groupContainer: IUIGroupContainer? { get }
    
    var groupItem: UI.View.GroupBar.Item { get }
    
}

public extension IUIGroupContentContainer {
    
    var groupContainer: IUIGroupContainer? {
        return self.parent as? IUIGroupContainer
    }
    
    func updateGroupBar(animated: Bool, completion: (() -> Void)? = nil) {
        guard let groupContainer = self.groupContainer else {
            completion?()
            return
        }
        groupContainer.updateBar(animated: animated, completion: completion)
    }
    
}
