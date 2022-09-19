//
//  KindKit
//

import Foundation

public protocol IUIStickyContainer : IUIContainer, IUIContainerParentable {
    
    var overlayView: UI.View.Bar { get }
    var overlayVisibility: Float { get }
    var overlayHidden: Bool { get }
    
    func updateOverlay(animated: Bool, completion: (() -> Void)?)
    
}

public extension IUIStickyContainer {
    
    func updateOverlay(animated: Bool = true, completion: (() -> Void)? = nil) {
        self.updateOverlay(animated: animated, completion: completion)
    }
    
}
