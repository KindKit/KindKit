//
//  KindKitView
//

import Foundation
import KindKitCore
import KindKitMath

public protocol IGroupBarViewDelegate : AnyObject {
    
    func pressed(groupBar: IGroupBarView, itemView: IView)
    
}

public protocol IGroupBarView : IBarView {
    
    var delegate: IGroupBarViewDelegate? { set get }
    
    var itemInset: InsetFloat { set get }
    
    var itemSpacing: Float { set get }
    
    var itemViews: [IBarItemView] { set get }
    
    var selectedItemView: IBarItemView? { set get }

}

public extension IGroupBarView {
    
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
