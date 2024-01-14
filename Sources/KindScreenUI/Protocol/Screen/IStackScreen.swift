//
//  KindKit
//

public protocol IStackScreen : IScreen {
}

public extension IStackScreen {
    
    @inlinable
    var stackContainer: IStackContainer? {
        return self.container as? IStackContainer
    }
    
}
