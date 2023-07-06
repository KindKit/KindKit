//
//  KindKit
//

import Foundation

@available(*, deprecated, renamed: "IStackScreen")
public typealias IUIStackScreen = IStackScreen

public protocol IStackScreen : IScreen {
}

public extension IStackScreen {
    
    @inlinable
    var stackContainer: IUIStackContainer? {
        return self.container as? IUIStackContainer
    }
    
}
