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
    
    @discardableResult
    func reload(backward: Bool, forward: Bool) -> Bool {
        guard let container = self.bookContainer else { return false }
        container.reload(backward: backward, forward: forward)
        return true
    }
    
}
