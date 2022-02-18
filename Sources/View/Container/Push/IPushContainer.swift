//
//  KindKitView
//

import Foundation
import KindKitCore
import KindKitMath

public protocol IPushContainer : IContainer, IContainerParentable {
    
    var additionalInset: InsetFloat { set get }
    var contentContainer: (IContainer & IContainerParentable)? { set get }
    var containers: [IPushContentContainer] { get }
    var previousContainer: IPushContentContainer? { get }
    var currentContainer: IPushContentContainer? { get }
    var animationVelocity: Float { set get }
    #if os(iOS)
    var interactiveLimit: Float { set get }
    #endif
    
    func present(container: IPushContentContainer, animated: Bool, completion: (() -> Void)?)
    func dismiss(container: IPushContentContainer, animated: Bool, completion: (() -> Void)?)
    
}

public extension IPushContainer {
    
    @inlinable
    func present(container: IPushContentContainer, animated: Bool = true, completion: (() -> Void)? = nil) {
        self.present(container: container, animated: animated, completion: completion)
    }
    
    @inlinable
    func dismiss(container: IPushContentContainer, animated: Bool = true, completion: (() -> Void)? = nil) {
        self.dismiss(container: container, animated: animated, completion: completion)
    }
    
}

public protocol IPushContentContainer : IContainer, IContainerParentable {
    
    var pushContainer: IPushContainer? { get }
    
    var pushDuration: TimeInterval? { get }
    
}

public extension IPushContentContainer {
    
    @inlinable
    var pushContainer: IPushContainer? {
        return self.parent as? IPushContainer
    }
    
    @inlinable
    func dismiss(animated: Bool = true, completion: (() -> Void)? = nil) {
        guard let pushContainer = self.pushContainer else {
            completion?()
            return
        }
        pushContainer.dismiss(container: self, animated: animated, completion: completion)
    }
    
}
