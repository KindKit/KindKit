//
//  KindKit
//

public protocol IDialogContainer : IContainer, IContainerParentable {
    
    var content: (IContainer & IContainerParentable)? { set get }
    var containers: [IDialogContentContainer] { get }
    var previous: IDialogContentContainer? { get }
    var current: IDialogContentContainer? { get }
    var animationVelocity: Double { set get }
#if os(iOS)
    var interactiveLimit: Double { set get }
#endif
    
    func present(container: IDialogContentContainer, animated: Bool, completion: (() -> Void)?)
    
    @discardableResult
    func dismiss(container: IDialogContentContainer, animated: Bool, completion: (() -> Void)?) -> Bool
    
}
