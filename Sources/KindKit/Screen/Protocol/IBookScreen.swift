//
//  KindKit
//

import Foundation

@available(*, deprecated, renamed: "IBookScreen")
public typealias IUIBookScreen = IBookScreen

public protocol IBookScreen : IScreen {
    
    func initialContainer() -> IUIBookContentContainer
    
    func backwardContainer(_ current: IUIBookContentContainer) -> IUIBookContentContainer?
    
    func forwardContainer(_ current: IUIBookContentContainer) -> IUIBookContentContainer?
    
    func change(current: IUIBookContentContainer)
    
    func beginInteractive()
    
    func finishInteractiveToBackward()
    
    func finishInteractiveToForward()
    
    func cancelInteractive()
    
}

public extension IBookScreen {
    
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

public extension IBookScreen {
    
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
