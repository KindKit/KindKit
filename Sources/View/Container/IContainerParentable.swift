//
//  KindKitView
//

import Foundation
#if os(iOS)
import UIKit
#endif
import KindKitCore
import KindKitMath

public protocol IContainerParentable : AnyObject {
    
    var parent: IContainer? { set get }
    
}

public extension IContainerParentable where Self : IContainer {
    
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
