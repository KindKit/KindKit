//
//  KindKit
//

import Foundation
#if os(iOS)
import UIKit
#endif

public protocol IUIContainerParentable : AnyObject {
    
    var parent: IUIContainer? { set get }
    
}

public extension IUIContainerParentable where Self : IUIContainer {
    
    #if os(iOS)
    
    var uiViewController: UIViewController? {
        return self.parent?.uiViewController
    }
    
    #endif
    
    func inheritedInsets(interactive: Bool) -> InsetFloat {
        guard let parent = self.parent else { return .zero }
        self.view.layoutIfNeeded()
        return parent.insets(of: self, interactive: interactive)
    }
    
    #if os(iOS)
    
    func setNeedUpdateStatusBar() {
        self.parent?.setNeedUpdateStatusBar()
    }
    
    func setNeedUpdateOrientations() {
        self.parent?.setNeedUpdateOrientations()
    }
    
    #endif
    
}
