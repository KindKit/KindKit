//
//  KindKit
//

import KindUI

public protocol IPageScreen : IScreen {
    
    var pageBar: PageBarView { get }
    var pageBarVisibility: Double { get }
    var pageBarHidden: Bool { get }
    
    func change(current: IPageContentContainer)
    
    func beginInteractive()
    
    func finishInteractiveToBackward()
    
    func finishInteractiveToForward()
    
    func cancelInteractive()
    
}

public extension IPageScreen {
    
    var pageBarVisibility: Double {
        return 1
    }
    
    var pageBarHidden: Bool {
        return false
    }
    
    func change(current: IPageContentContainer) {
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

public extension IPageScreen {
    
    @inlinable
    var pageContainer: IPageContainer? {
        return self.container as? IPageContainer
    }
    
    @discardableResult
    func update(animated: Bool, completion: (() -> Void)? = nil) -> Bool {
        guard let container = self.pageContainer else { return false }
        container.updateBar(animated: animated, completion: completion)
        return true
    }
    
}
