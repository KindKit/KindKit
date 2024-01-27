//
//  KindKit
//

import Foundation

public protocol IPushContentContainer : IContainer, IContainerParentable {
    
    var pushContainer: IPushContainer? { get }
    
    var pushPlacement: Push.Placement { get }
    var pushOptions: Push.Options { get }
    var pushDuration: TimeInterval? { get }
    
}

public extension IPushContentContainer {
    
    @inlinable
    var pushContainer: IPushContainer? {
        return self.parent as? IPushContainer
    }
    
    @discardableResult
    func dismiss(animated: Bool = true, completion: (() -> Void)? = nil) -> Bool {
        guard let container = self.pushContainer else { return false }
        container.dismiss(container: self, animated: animated, completion: completion)
        return true
    }
    
}
