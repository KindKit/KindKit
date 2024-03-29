//
//  KindKit
//

import Foundation

@available(*, deprecated, renamed: "IPageScreen")
public typealias IUIPageScreen = IPageScreen

public protocol IPageScreen : IScreen {
    
    var pageBar: UI.View.PageBar { get }
    var pageBarVisibility: Double { get }
    var pageBarHidden: Bool { get }
    
    func change(current: IUIPageContentContainer)
    
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

public extension IPageScreen {
    
    @inlinable
    var pageContainer: IUIPageContainer? {
        return self.container as? IUIPageContainer
    }
    
    @discardableResult
    func update(animated: Bool, completion: (() -> Void)? = nil) -> Bool {
        guard let container = self.pageContainer else { return false }
        container.updateBar(animated: animated, completion: completion)
        return true
    }
    
}
