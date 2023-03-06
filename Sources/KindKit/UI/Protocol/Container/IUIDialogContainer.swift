//
//  KindKit
//

import Foundation

public protocol IUIDialogContainer : IUIContainer, IUIContainerParentable {
    
    var content: (IUIContainer & IUIContainerParentable)? { set get }
    var containers: [IUIDialogContentContainer] { get }
    var previous: IUIDialogContentContainer? { get }
    var current: IUIDialogContentContainer? { get }
    var animationVelocity: Double { set get }
#if os(iOS)
    var interactiveLimit: Double { set get }
#endif
    
    func present(container: IUIDialogContentContainer, animated: Bool, completion: (() -> Void)?)
    func dismiss(container: IUIDialogContentContainer, animated: Bool, completion: (() -> Void)?)
    
}
