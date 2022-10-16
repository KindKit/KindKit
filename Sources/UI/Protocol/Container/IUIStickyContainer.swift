//
//  KindKit
//

import Foundation

public protocol IUIStickyContainer : IUIContainer, IUIContainerParentable {
    
    var sticky: UI.View.Bar { get }
    var stickyVisibility: Float { get }
    var stickyHidden: Bool { get }
    
    func updateSticky(animated: Bool, completion: (() -> Void)?)
    
}

public extension IUIStickyContainer {
    
    func updateSticky(animated: Bool = true, completion: (() -> Void)? = nil) {
        self.updateSticky(animated: animated, completion: completion)
    }
    
}
