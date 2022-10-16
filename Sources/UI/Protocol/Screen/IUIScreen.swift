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
#if os(iOS)
    var statusBar: UIStatusBarStyle { get }
    var statusBarAnimation: UIStatusBarAnimation { get }
    var statusBarHidden: Bool { get }
    var supportedOrientations: UIInterfaceOrientationMask { get }
#endif
    
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
    
    func inheritedInsets(interactive: Bool = false) -> InsetFloat {
        return self.container?.inheritedInsets(interactive: interactive) ?? .zero
    }

#if os(iOS)
    
    var uiViewController: UIViewController? {
        return self.container?.uiViewController
    }
    
    var statusBar: UIStatusBarStyle {
        return .default
    }
    
    var statusBarAnimation: UIStatusBarAnimation {
        return .fade
    }
    
    var statusBarHidden: Bool {
        return false
    }
    
    var supportedOrientations: UIInterfaceOrientationMask {
        return .all
    }
    
    func setNeedUpdateStatusBar() {
        self.container?.setNeedUpdateStatusBar()
    }
    
    func setNeedUpdateOrientations() {
        self.container?.setNeedUpdateOrientations()
    }
    
    @discardableResult
    func dismiss(animated: Bool = true, completion: (() -> Void)? = nil) -> Bool {
        guard let container = self.container else { return false }
        return container.dismiss(animated: animated, completion: completion)
    }
    
#endif
    
}
