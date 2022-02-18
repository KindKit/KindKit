//
//  KindKitView
//

import Foundation
import KindKitCore
import KindKitMath

public protocol IStackScreen : IScreen {
}

public extension IStackScreen {
    
    @inlinable
    var stackContainer: IStackContainer? {
        return self.container as? IStackContainer
    }
    
}
