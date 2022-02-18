//
//  KindKitView
//

import Foundation
import KindKitCore
import KindKitMath

public protocol IBookContainer : IContainer, IContainerParentable {
    
    var backward: IBookContentContainer? { get }
    var current: IBookContentContainer? { get }
    var forward: IBookContentContainer? { get }
    var animationVelocity: Float { set get }
    #if os(iOS)
    var interactiveLimit: Float { set get }
    #endif
    
    func reload(backward: Bool, forward: Bool)
    
    func set(current: IBookContentContainer, animated: Bool, completion: (() -> Void)?)
    
}

public protocol IBookContentContainer : IContainer, IContainerParentable {
    
    var bookIdentifier: Any { get }
    
}

public extension IBookContainer {
    
    @inlinable
    func set(current: IBookContentContainer, animated: Bool = true, completion: (() -> Void)? = nil) {
        self.set(current: current, animated: animated, completion: completion)
    }
    
}

public extension IBookContentContainer {
    
    var bookContainer: IBookContainer? {
        return self.parent as? IBookContainer
    }
    
}
