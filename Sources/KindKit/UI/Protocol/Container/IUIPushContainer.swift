//
//  KindKit
//

import Foundation

public protocol IUIPushContainer : IUIContainer, IUIContainerParentable {
    
    var inset: Inset { set get }
    var content: (IUIContainer & IUIContainerParentable)? { set get }
    var containers: [IUIPushContentContainer] { get }
    var previous: IUIPushContentContainer? { get }
    var current: IUIPushContentContainer? { get }
    var animationVelocity: Double { set get }
#if os(iOS)
    var interactiveLimit: Double { set get }
#endif
    
    func present(container: IUIPushContentContainer, animated: Bool, completion: (() -> Void)?)
    
    @discardableResult
    func dismiss(container: IUIPushContentContainer, animated: Bool, completion: (() -> Void)?) -> Bool
    
}
