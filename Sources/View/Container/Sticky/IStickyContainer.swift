//
//  KindKitView
//

import Foundation
import KindKitCore
import KindKitMath

public protocol IStickyContainer : IContainer, IContainerParentable {
    
    var overlayView: IBarView { get }
    var overlayVisibility: Float { get }
    var overlayHidden: Bool { get }
    
    func updateOverlay(animated: Bool, completion: (() -> Void)?)
    
}

public extension IStickyContainer {
    
    func updateOverlay(animated: Bool = true, completion: (() -> Void)? = nil) {
        self.updateOverlay(animated: animated, completion: completion)
    }
    
}
