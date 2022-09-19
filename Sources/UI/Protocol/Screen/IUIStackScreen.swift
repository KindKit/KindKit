//
//  KindKit
//

import Foundation

public protocol IUIStackScreen : IUIScreen {
}

public extension IUIStackScreen {
    
    @inlinable
    var stackContainer: IUIStackContainer? {
        return self.container as? IUIStackContainer
    }
    
}
