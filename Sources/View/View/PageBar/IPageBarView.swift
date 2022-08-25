//
//  KindKitView
//

import Foundation
import KindKitCore
import KindKitMath

public protocol IPageBarViewDelegate : AnyObject {
    
    func pressed(pageBar: IPageBarView, itemView: IView)
    
}

public protocol IPageBarView : IBarView {
    
    var delegate: IPageBarViewDelegate? { set get }
    
    var leadingView: IView? { set get }
    
    var trailingView: IView? { set get }

    var indicatorView: IView { set get }
    
    var itemInset: InsetFloat { set get }
    
    var itemSpacing: Float { set get }
    
    var itemViews: [IBarItemView] { set get }
    
    var selectedItemView: IBarItemView? { set get }
    
    func beginTransition()
    
    func transition(to view: IBarItemView, progress: PercentFloat)
    
    func finishTransition(to view: IBarItemView)
    
    func cancelTransition()

}

public extension IPageBarView {
    
    @inlinable
    @discardableResult
    func leadingView(_ value: IView?) -> Self {
        self.leadingView = value
        return self
    }
    
    @inlinable
    @discardableResult
    func trailingView(_ value: IView?) -> Self {
        self.trailingView = value
        return self
    }
    
    @inlinable
    @discardableResult
    func indicatorView(_ value: IView) -> Self {
        self.indicatorView = value
        return self
    }
    
    @inlinable
    @discardableResult
    func itemInset(_ value: InsetFloat) -> Self {
        self.itemInset = value
        return self
    }
    
    @inlinable
    @discardableResult
    func itemSpacing(_ value: Float) -> Self {
        self.itemSpacing = value
        return self
    }
    
    @inlinable
    @discardableResult
    func itemViews(_ value: [IBarItemView]) -> Self {
        self.itemViews = value
        return self
    }
    
    @inlinable
    @discardableResult
    func selectedItemView(_ value: IBarItemView?) -> Self {
        self.selectedItemView = value
        return self
    }
    
}
