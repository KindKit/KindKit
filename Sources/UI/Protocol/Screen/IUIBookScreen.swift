//
//  KindKit
//

import Foundation

public protocol IUIBookScreen : IUIScreen {
    
    func initialContainer() -> IUIBookContentContainer
    
    func backwardContainer(_ current: IUIBookContentContainer) -> IUIBookContentContainer?
    
    func forwardContainer(_ current: IUIBookContentContainer) -> IUIBookContentContainer?
    
    func change(current: IUIBookContentContainer)
    
    func beginInteractive()
    
    func finishInteractiveToBackward()
    
    func finishInteractiveToForward()
    
    func cancelInteractive()
    
}

public extension IUIBookScreen {
    
    func change(current: IUIBookContentContainer) {
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

public extension IUIBookScreen {
    
    @inlinable
    var bookContainer: IUIBookContainer? {
        return self.container as? IUIBookContainer
    }
    
    @inlinable
    func reload(backward: Bool, forward: Bool) {
        self.bookContainer?.reload(backward: backward, forward: forward)
    }
    
}
