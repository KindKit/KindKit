//
//  KindKitView
//

import Foundation
import KindKitCore

public protocol IBookScreen : IScreen {
    
    func initialContainer() -> IBookContentContainer
    
    func backwardContainer(_ current: IBookContentContainer) -> IBookContentContainer?
    
    func forwardContainer(_ current: IBookContentContainer) -> IBookContentContainer?
    
    func change(current: IBookContentContainer)
    
    func beginInteractive()
    
    func finishInteractiveToBackward()
    
    func finishInteractiveToForward()
    
    func cancelInteractive()
    
}

public extension IBookScreen {
    
    func change(current: IBookContentContainer) {
    }
    
    func beginInteractive() {
    }
    
    func finishInteractiveToBackward() {
    }
    
    func finishInteractiveToForward() {
    }
    
    func cancelInteractive() {
    }
    
}

public extension IBookScreen {
    
    @inlinable
    var bookContainer: IBookContainer? {
        return self.container as? IBookContainer
    }
    
    @inlinable
    func reload(backward: Bool, forward: Bool) {
        self.bookContainer?.reload(backward: backward, forward: forward)
    }
    
}
