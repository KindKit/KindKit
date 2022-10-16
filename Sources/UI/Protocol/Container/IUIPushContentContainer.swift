//
//  KindKit
//

import Foundation

public protocol IUIPushContentContainer : IUIContainer, IUIContainerParentable {
    
    var pushContainer: IUIPushContainer? { get }
    
    var pushDuration: TimeInterval? { get }
    
}

public extension IUIPushContentContainer {
    
    @inlinable
    var pushContainer: IUIPushContainer? {
        return self.parent as? IUIPushContainer
    }
    
    @discardableResult
    func dismiss(animated: Bool = true, completion: (() -> Void)? = nil) -> Bool {
        guard let container = self.pushContainer else { return false }
        container.dismiss(container: self, animated: animated, completion: completion)
        return true
    }
    
}
