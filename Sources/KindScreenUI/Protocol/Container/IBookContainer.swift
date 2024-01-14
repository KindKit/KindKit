//
//  KindKit
//

public protocol IBookContainer : IContainer, IContainerParentable {
    
    var backward: IBookContentContainer? { get }
    var current: IBookContentContainer? { get }
    var forward: IBookContentContainer? { get }
    var animationVelocity: Double { set get }
#if os(iOS)
    var interactiveLimit: Double { set get }
#endif
    
    func reload(backward: Bool, forward: Bool)
    
    func set(current: IBookContentContainer, animated: Bool, completion: (() -> Void)?)
    
}
