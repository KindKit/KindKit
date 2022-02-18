//
//  KindKitView
//

import Foundation
import KindKitCore
import KindKitMath

public protocol IScreen : AnyObject {
    
    var container: IContainer? { set get }
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

public extension IScreen {
    
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

public extension IScreen {
    
    func inheritedInsets(interactive: Bool = false) -> InsetFloat {
        return self.container?.inheritedInsets(interactive: interactive) ?? .zero
    }
    
}

#if os(iOS)

import UIKit

public protocol IScreenStatusable : AnyObject {
    
    var statusBarHidden: Bool { get }
    var statusBarStyle: UIStatusBarStyle { get }
    var statusBarAnimation: UIStatusBarAnimation { get }
    
}

public extension IScreenStatusable where Self : IScreen {
    
    var statusBarHidden: Bool {
        return false
    }
    var statusBarStyle: UIStatusBarStyle {
        return .default
    }
    var statusBarAnimation: UIStatusBarAnimation {
        return .fade
    }
    
    func setNeedUpdateStatusBar() {
        self.container?.setNeedUpdateStatusBar()
    }
    
}

public protocol IScreenOrientable : AnyObject {
    
    var supportedOrientations: UIInterfaceOrientationMask { get }
    
}

public extension IScreenOrientable where Self : IScreen {
    
    var supportedOrientations: UIInterfaceOrientationMask {
        return .all
    }
    
    func setNeedUpdateOrientations() {
        self.container?.setNeedUpdateOrientations()
    }
    
}

#endif
