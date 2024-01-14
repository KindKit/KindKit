//
//  KindKit
//

import KindUI

public protocol IStickyContainer : IContainer, IContainerParentable {
    
    var sticky: BarView { get }
    var stickyVisibility: Double { get }
    var stickyHidden: Bool { get }
    
    func updateSticky(animated: Bool, completion: (() -> Void)?)
    
}
