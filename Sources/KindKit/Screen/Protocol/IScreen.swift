//
//  KindKit
//

import Foundation
#if os(iOS)
import UIKit
#endif

@available(*, deprecated, renamed: "IScreen")
public typealias IUIScreen = IScreen

public protocol IScreen : AnyObject {
    
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
#if os(iOS)
    func snake() -> Bool
#endif
    
    func didChangeAppearance()
#if os(iOS)
    func didChange(orientation: UIInterfaceOrientation)
#endif

    func prepareShow(interactive: Bool)
    func finishShow(interactive: Bool)
    func cancelShow(interactive: Bool)
    
    func prepareHide(interactive: Bool)
    func finishHide(interactive: Bool)
    func cancelHide(interactive: Bool)
    
}

public extension IScreen {
    
    var isPresented: Bool {
        return self.container?.isPresented ?? false
    }
    
    var shouldInteractive: Bool {
        return true
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
    
    
    var orientation: UIInterfaceOrientation {
        return self.container?.orientation ?? .unknown
    }
    
#endif
    
    var inset: UI.Container.AccumulateInset {
        guard let parentInset = self.container?.parentInset() else {
            return .zero
        }
        return parentInset
    }
    
    func setup() {
    }
    
    func destroy() {
    }
    
    func activate() -> Bool {
        return false
    }
    
#if os(iOS)
    
    func endEditing() {
        guard let viewController = self.uiViewController else { return }
        viewController.view.endEditing(false)
    }
    
    func snake() -> Bool {
        return false
    }
    
#endif
    
    func didChangeAppearance() {
    }
    
#if os(iOS)
    
    func didChange(orientation: UIInterfaceOrientation) {
    }
    
#endif
    
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
    
#if os(iOS)
    
    func refreshStatusBar() {
        self.container?.refreshStatusBar()
    }
    
    func refreshOrientations() {
        self.container?.refreshOrientations()
    }
    
#endif
    
    @discardableResult
    func close(animated: Bool = true, completion: (() -> Void)? = nil) -> Bool {
        guard let container = self.container else { return false }
        return container.close(animated: animated, completion: completion)
    }
    
}
