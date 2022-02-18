//
//  KindKitView
//

import Foundation
import KindKitCore

public protocol IPageScreen : IScreen {
    
    associatedtype PageBar : IPageBarView
    
    var pageBarView: PageBar { get }
    var pageBarVisibility: Float { get }
    var pageBarHidden: Bool { get }
    
    func change(current: IPageContentContainer)
    
    func beginInteractive()
    
    func finishInteractiveToBackward()
    
    func finishInteractiveToForward()
    
    func cancelInteractive()
    
}

public extension IPageScreen {
    
    @inlinable
    var pageContainer: IPageContainer? {
        return self.container as? IPageContainer
    }
    
    var pageBarVisibility: Float {
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
    
    func updatePageBar(animated: Bool, completion: (() -> Void)? = nil) {
        guard let pageContainer = self.pageContainer else {
            completion?()
            return
        }
        pageContainer.updateBar(animated: animated, completion: completion)
    }
    
}
