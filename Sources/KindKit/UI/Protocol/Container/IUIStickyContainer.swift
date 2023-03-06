//
//  KindKit
//

import Foundation

public protocol IUIStickyContainer : IUIContainer, IUIContainerParentable {
    
    var sticky: UI.View.Bar { get }
    var stickyVisibility: Double { get }
    var stickyHidden: Bool { get }
    
    func updateSticky(animated: Bool, completion: (() -> Void)?)
    
}
