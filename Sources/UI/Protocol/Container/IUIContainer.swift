//
//  KindKit
//

import Foundation
#if os(iOS)
import UIKit
#endif

public protocol IUIContainer : AnyObject {
    
    var shouldInteractive: Bool { get }
#if os(iOS)
    var statusBarHidden: Bool { get }
    var statusBarStyle: UIStatusBarStyle { get }
    var statusBarAnimation: UIStatusBarAnimation { get }
    var supportedOrientations: UIInterfaceOrientationMask { get }
    var viewController: UIViewController? { get }
#endif
    var isPresented: Bool { get }
    var view: IUIView { get }
    
#if os(iOS)
    func setNeedUpdateStatusBar()
    func setNeedUpdateOrientations()
#endif
    
    func inheritedInsets(interactive: Bool) -> InsetFloat
    func insets(of container: IUIContainer, interactive: Bool) -> InsetFloat
    func didChangeInsets()
    
    func activate() -> Bool
    
    func didChangeAppearance()
    
    func prepareShow(interactive: Bool)
    func finishShow(interactive: Bool)
    func cancelShow(interactive: Bool)
    
    func prepareHide(interactive: Bool)
    func finishHide(interactive: Bool)
    func cancelHide(interactive: Bool)
    
}

public extension IUIContainer {
    
    func inheritedInsets(interactive: Bool) -> InsetFloat {
        return .zero
    }
    
}
