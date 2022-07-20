//
//  KindKitView
//

import Foundation
#if os(iOS)
import UIKit
#endif
import KindKitCore
import KindKitMath

public protocol IRootContainerDelegate : AnyObject {
    
    #if os(iOS)
    
    func viewController() -> UIViewController?
    
    func updateOrientations()
    func updateStatusBar()
    
    #endif
    
}

public protocol IRootContainer : IContainer {
    
    var delegate: IRootContainerDelegate? { set get }
    var statusBarView: IStatusBarView? { set get }
    var safeArea: InsetFloat { set get }
    var overlayContainer: IRootContentContainer? { set get }
    var contentContainer: IRootContentContainer { set get }
    
}

public protocol IRootContentContainer : IContainer, IContainerParentable {
    
    var rootContainer: IRootContainer? { get }
    
}

public extension IRootContentContainer {
    
    @inlinable
    var rootContainer: IRootContainer? {
        return self.parent as? IRootContainer
    }
    
}
