//
//  KindKit
//

import Foundation

public protocol IUIGroupContainer : IUIContainer, IUIContainerParentable {
    
    var bar: UI.View.GroupBar { get }
    var barVisibility: Float { get }
    var barHidden: Bool { get }
    var containers: [IUIGroupContentContainer] { get }
    var backward: IUIGroupContentContainer? { get }
    var current: IUIGroupContentContainer? { get }
    var forward: IUIGroupContentContainer? { get }
    var allowAnimationUserInteraction: Bool { set get }
    var animationVelocity: Float { set get }
    
    func updateBar(animated: Bool, completion: (() -> Void)?)
    
    func update(container: IUIGroupContentContainer, animated: Bool, completion: (() -> Void)?)
    
    func set(containers: [IUIGroupContentContainer], current: IUIGroupContentContainer?, animated: Bool, completion: (() -> Void)?)
    func set(current: IUIGroupContentContainer, animated: Bool, completion: (() -> Void)?)
    
}
