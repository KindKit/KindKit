//
//  KindKit
//

import Foundation

@available(*, deprecated, renamed: "IScreenPushable")
public typealias IUIScreenPushable = IScreenPushable

public protocol IScreenPushable : AnyObject {
    
    var pushPlacement: UI.Push.Placement { get }
    var pushOptions: UI.Push.Options { get }
    var pushDuration: TimeInterval? { get }
    
}

public extension IScreenPushable {
    
    var pushPlacement: UI.Push.Placement {
        return .top
    }
    
    var pushOptions: UI.Push.Options {
        return []
    }
    
    var pushDuration: TimeInterval? {
        return 3
    }
    
}

public extension IScreenPushable where Self : IScreen {
    
    @inlinable
    var pushContentContainer: IUIPushContentContainer? {
        guard let contentContainer = self.container as? IUIPushContentContainer else { return nil }
        return contentContainer
    }
    
    @inlinable
    var pushContainer: IUIPushContainer? {
        return self.pushContentContainer?.pushContainer
    }
    
}
