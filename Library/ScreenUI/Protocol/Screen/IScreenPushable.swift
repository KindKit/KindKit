//
//  KindKit
//

import Foundation

public protocol IScreenPushable : AnyObject {
    
    var pushPlacement: Push.Placement { get }
    var pushOptions: Push.Options { get }
    var pushDuration: TimeInterval? { get }
    
}

public extension IScreenPushable {
    
    var pushPlacement: Push.Placement {
        return .top
    }
    
    var pushOptions: Push.Options {
        return []
    }
    
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
    
}
