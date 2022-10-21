//
//  KindKit
//

import Foundation

public protocol IUIBookContainer : IUIContainer, IUIContainerParentable {
    
    var backward: IUIBookContentContainer? { get }
    var current: IUIBookContentContainer? { get }
    var forward: IUIBookContentContainer? { get }
    var animationVelocity: Float { set get }
#if os(iOS)
    var interactiveLimit: Float { set get }
#endif
    
    func reload(backward: Bool, forward: Bool)
    
    func set(current: IUIBookContentContainer, animated: Bool, completion: (() -> Void)?)
    
}
