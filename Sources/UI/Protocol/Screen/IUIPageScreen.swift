//
//  KindKit
//

import Foundation

public protocol IUIPageScreen : IUIScreen {
    
    var pageBar: UI.View.PageBar { get }
    var pageBarVisibility: Float { get }
    var pageBarHidden: Bool { get }
    
    func change(current: IUIPageContentContainer)
    
    func beginInteractive()
    
    func finishInteractiveToBackward()
    
    func finishInteractiveToForward()
    
    func cancelInteractive()
    
}

public extension IUIPageScreen {
    
    @inlinable
    var pageContainer: IUIPageContainer? {
        return self.container as? IUIPageContainer
    }
    
    var pageBarVisibility: Float {
        return 1
    }
    
    var pageBarHidden: Bool {
        return false
    }
    
    func change(current: IUIPageContentContainer) {
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

public extension IUIPageScreen {
    
    func updatePageBar(animated: Bool, completion: (() -> Void)? = nil) {
        guard let pageContainer = self.pageContainer else {
            completion?()
            return
        }
        pageContainer.updateBar(animated: animated, completion: completion)
    }
    
}
