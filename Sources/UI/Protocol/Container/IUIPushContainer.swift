//
//  KindKit
//

import Foundation

public protocol IUIPushContainer : IUIContainer, IUIContainerParentable {
    
    var inset: InsetFloat { set get }
    var content: (IUIContainer & IUIContainerParentable)? { set get }
    var containers: [IUIPushContentContainer] { get }
    var previous: IUIPushContentContainer? { get }
    var current: IUIPushContentContainer? { get }
    var animationVelocity: Float { set get }
#if os(iOS)
    var interactiveLimit: Float { set get }
#endif
    
    func present(container: IUIPushContentContainer, animated: Bool, completion: (() -> Void)?)
    func dismiss(container: IUIPushContentContainer, animated: Bool, completion: (() -> Void)?)
    
}
