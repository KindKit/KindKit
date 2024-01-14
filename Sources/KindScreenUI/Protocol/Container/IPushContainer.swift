//
//  KindKit
//

import KindMath

public protocol IPushContainer : IContainer, IContainerParentable {
    
    var inset: Inset { set get }
    var content: (IContainer & IContainerParentable)? { set get }
    var containers: [IPushContentContainer] { get }
    var previous: IPushContentContainer? { get }
    var current: IPushContentContainer? { get }
    var animationVelocity: Double { set get }
#if os(iOS)
    var interactiveLimit: Double { set get }
#endif
    
    func present(container: IPushContentContainer, animated: Bool, completion: (() -> Void)?)
    
    @discardableResult
    func dismiss(container: IPushContentContainer, animated: Bool, completion: (() -> Void)?) -> Bool
    
}
