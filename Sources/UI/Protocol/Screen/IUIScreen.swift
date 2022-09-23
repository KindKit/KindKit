//
//  KindKit
//

import Foundation
#if os(iOS)
import UIKit
#endif

public protocol IUIScreen : AnyObject {
    
    var container: IUIContainer? { set get }
    var shouldInteractive: Bool { get }
    
    func setup()
    func destroy()
    
    func activate() -> Bool
    
    func didChangeAppearance()

    func prepareShow(interactive: Bool)
    func finishShow(interactive: Bool)
    func cancelShow(interactive: Bool)
    
    func prepareHide(interactive: Bool)
    func finishHide(interactive: Bool)
    func cancelHide(interactive: Bool)
    
}

public extension IUIScreen {
    
    var shouldInteractive: Bool {
        return true
    }
    
    var isPresented: Bool {
        return self.container?.isPresented ?? false
    }
    
    func setup() {
    }
    
    func destroy() {
    }
    
    func activate() -> Bool {
        return false
    }
    
    func didChangeAppearance() {
    }
    
    func prepareShow(interactive: Bool) {
    }
    
    func finishShow(interactive: Bool) {
    }
    
    func cancelShow(interactive: Bool) {
    }
    
    func prepareHide(interactive: Bool) {
    }
    
    func finishHide(interactive: Bool) {
    }
    
    func cancelHide(interactive: Bool) {
    }
    
}

public extension IUIScreen {
    
    #if os(iOS)
    
    var viewController: UIViewController? {
        return self.container?.viewController
    }
    
    #endif
    
    func inheritedInsets(interactive: Bool = false) -> InsetFloat {
        return self.container?.inheritedInsets(interactive: interactive) ?? .zero
    }
    
}

#if os(iOS)

public protocol IScreenStatusable : AnyObject {
    
    var statusBar: UIStatusBarStyle { get }
    var statusBarAnimation: UIStatusBarAnimation { get }
    var statusBarHidden: Bool { get }
    
}

public extension IScreenStatusable where Self : IUIScreen {
    
    var statusBar: UIStatusBarStyle {
        return .default
    }
    
    var statusBarAnimation: UIStatusBarAnimation {
        return .fade
    }
    
    var statusBarHidden: Bool {
        return false
    }
    
    func setNeedUpdateStatusBar() {
        self.container?.setNeedUpdateStatusBar()
    }
    
}

public protocol IScreenOrientable : AnyObject {
    
    var supportedOrientations: UIInterfaceOrientationMask { get }
    
}

public extension IScreenOrientable where Self : IUIScreen {
    
    var supportedOrientations: UIInterfaceOrientationMask {
        return .all
    }
    
    func setNeedUpdateOrientations() {
        self.container?.setNeedUpdateOrientations()
    }
    
}

#endif
