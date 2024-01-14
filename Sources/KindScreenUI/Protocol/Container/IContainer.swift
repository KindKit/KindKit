//
//  KindKit
//

import KindUI

public protocol IContainer : AnyObject {
    
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
    var view: IView { get }
    
    func apply(contentInset: Container.AccumulateInset)
    
    func parentInset() -> Container.AccumulateInset
    func parentInset(for container: IContainer) -> Container.AccumulateInset
    func contentInset() -> Container.AccumulateInset

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
    func close(container: IContainer, animated: Bool, completion: (() -> Void)?) -> Bool
    
}

public extension IContainer {
    
    func parentInset() -> Container.AccumulateInset {
        return .zero
    }
    
}
