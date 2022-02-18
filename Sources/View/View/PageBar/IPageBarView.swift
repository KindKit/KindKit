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
    
    var leadingView: IView? { get }
    
    var trailingView: IView? { get }

    var indicatorView: IView { get }
    
    var itemInset: InsetFloat { get }
    
    var itemSpacing: Float { get }
    
    var itemViews: [IBarItemView] { get }
    
    var selectedItemView: IBarItemView? { get }
    
    @discardableResult
    func leadingView(_ value: IView?) -> Self
    
    @discardableResult
    func trailingView(_ value: IView?) -> Self
    
    @discardableResult
    func indicatorView(_ value: IView) -> Self
    
    @discardableResult
    func itemInset(_ value: InsetFloat) -> Self
    
    @discardableResult
    func itemSpacing(_ value: Float) -> Self
    
    @discardableResult
    func itemViews(_ value: [IBarItemView]) -> Self
    
    @discardableResult
    func selectedItemView(_ value: IBarItemView?) -> Self
    
    func beginTransition()
    
    func transition(to view: IBarItemView, progress: Float)
    
    func finishTransition(to view: IBarItemView)
    
    func cancelTransition()

}
