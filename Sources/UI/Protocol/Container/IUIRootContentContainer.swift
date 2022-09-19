//
//  KindKit
//

import Foundation

public protocol IUIRootContentContainer : IUIContainer, IUIContainerParentable {
    
    var rootContainer: UI.Container.Root? { get }
    
}

public extension IUIRootContentContainer {
    
    @inlinable
    var rootContainer: UI.Container.Root? {
        return self.parent as? UI.Container.Root
    }
    
}
