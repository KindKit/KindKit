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
    var orientation: UIInterfaceOrientation { get }
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
#if os(iOS)
    func didChange(orientation: UIInterfaceOrientation)
#endif
    
    func prepareShow(interactive: Bool)
    func finishShow(interactive: Bool)
    func cancelShow(interactive: Bool)
    
    func prepareHide(interactive: Bool)
    func finishHide(interactive: Bool)
    func cancelHide(interactive: Bool)
    
    func close(animated: Bool, completion: (() -> Void)?) -> Bool
    func close(container: IUIContainer, animated: Bool, completion: (() -> Void)?) -> Bool
    
}

public extension IUIContainer {
    
    func parentInset() -> UI.Container.AccumulateInset {
        return .zero
    }
    
}
