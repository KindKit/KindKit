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
    
    @inlinable
    func dismiss(animated: Bool = true, completion: (() -> Void)? = nil) {
        guard let pushContainer = self.pushContainer else {
            completion?()
            return
        }
        pushContainer.dismiss(container: self, animated: animated, completion: completion)
    }
    
}
