//
//  KindKitView
//

import Foundation
import KindKitCore
import KindKitMath

public protocol IScreenPushable : AnyObject {
    
    var pushDuration: TimeInterval? { get }
    
}

public extension IScreenPushable {
    
    var pushDuration: TimeInterval? {
        return 3
    }
    
}

public extension IScreenPushable where Self : IScreen {
    
    @inlinable
    var pushContentContainer: IPushContentContainer? {
        guard let contentContainer = self.container as? IPushContentContainer else { return nil }
        return contentContainer
    }
    
    @inlinable
    var pushContainer: IPushContainer? {
        return self.pushContentContainer?.pushContainer
    }
    
    @inlinable
    func dismiss(animated: Bool = true, completion: (() -> Void)? = nil) {
        self.pushContentContainer?.dismiss(animated: animated, completion: completion)
    }
    
}
