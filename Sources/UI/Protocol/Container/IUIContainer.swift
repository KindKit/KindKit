//
//  KindKit
//

import Foundation
#if os(macOS)
import AppKit
#elseif os(iOS)
import UIKit
#endif

public protocol IUIContainer : AnyObject {
    
    var shouldInteractive: Bool { get }
#if os(macOS)
    var nsViewController: NSViewController? { get }
#elseif os(iOS)
    var statusBar: UIStatusBarStyle { get }
    var statusBarAnimation: UIStatusBarAnimation { get }
    var statusBarHidden: Bool { get }
    var supportedOrientations: UIInterfaceOrientationMask { get }
    var uiViewController: UIViewController? { get }
#endif
    var isPresented: Bool { get }
    var view: IUIView { get }
    
    func apply(contentInset: UI.Container.AccumulateInset)
    
    func parentInset() -> UI.Container.AccumulateInset
    func parentInset(for container: IUIContainer) -> UI.Container.AccumulateInset
    func contentInset() -> UI.Container.AccumulateInset

    func refreshParentInset()
    func refreshContentInset()
#if os(iOS)
    func refreshStatusBar()
    func refreshOrientations()
#endif

    func activate() -> Bool
#if os(iOS)
    func snake() -> Bool
#endif
    
    func didChangeAppearance()
    
    func prepareShow(interactive: Bool)
    func finishShow(interactive: Bool)
    func cancelShow(interactive: Bool)
    
    func prepareHide(interactive: Bool)
    func finishHide(interactive: Bool)
    func cancelHide(interactive: Bool)
    
}

public extension IUIContainer {
    
    func parentInset() -> UI.Container.AccumulateInset {
        return .zero
    }

#if os(macOS)
    
    @discardableResult
    func dismiss(animated: Bool = true, completion: (() -> Void)? = nil) -> Bool {
        guard let viewController = self.nsViewController else { return false }
        guard let parentViewController = viewController.presentingViewController else { return false }
        parentViewController.dismiss(viewController)
        completion?()
        return true
    }
    
#elseif os(iOS)
    
    @discardableResult
    func dismiss(animated: Bool = true, completion: (() -> Void)? = nil) -> Bool {
        guard let viewController = self.uiViewController else { return false }
        viewController.dismiss(animated: animated, completion: completion)
        return true
    }
    
#endif
    
}
