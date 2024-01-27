//
//  KindKit
//

import KindUI

public protocol IGroupContainer : IContainer, IContainerParentable {
    
    var bar: GroupBarView { get }
    var barVisibility: Double { get }
    var barHidden: Bool { get }
    var containers: [IGroupContentContainer] { get }
    var backward: IGroupContentContainer? { get }
    var current: IGroupContentContainer? { get }
    var forward: IGroupContentContainer? { get }
    var allowAnimationUserInteraction: Bool { set get }
    var animationVelocity: Double { set get }
    
    func updateBar(animated: Bool, completion: (() -> Void)?)
    
    func update(container: IGroupContentContainer, animated: Bool, completion: (() -> Void)?)
    
    func set(containers: [IGroupContentContainer], current: IGroupContentContainer?, animated: Bool, completion: (() -> Void)?)
    func set(current: IGroupContentContainer, animated: Bool, completion: (() -> Void)?)
    
}
