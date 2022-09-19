//
//  KindKit
//

import Foundation

public protocol IUIScreenPushable : AnyObject {
    
    var pushDuration: TimeInterval? { get }
    
}

public extension IUIScreenPushable {
    
    var pushDuration: TimeInterval? {
        return 3
    }
    
}

public extension IUIScreenPushable where Self : IUIScreen {
    
    @inlinable
    var pushContentContainer: IUIPushContentContainer? {
        guard let contentContainer = self.container as? IUIPushContentContainer else { return nil }
        return contentContainer
    }
    
    @inlinable
    var pushContainer: IUIPushContainer? {
        return self.pushContentContainer?.pushContainer
    }
    
    @inlinable
    func dismiss(animated: Bool = true, completion: (() -> Void)? = nil) {
        self.pushContentContainer?.dismiss(animated: animated, completion: completion)
    }
    
}
