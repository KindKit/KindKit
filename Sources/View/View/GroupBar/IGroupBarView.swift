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
    
    @discardableResult
    func itemInset(_ value: InsetFloat) -> Self
    
    @discardableResult
    func itemSpacing(_ value: Float) -> Self
    
    @discardableResult
    func itemViews(_ value: [IBarItemView]) -> Self
    
    @discardableResult
    func selectedItemView(_ value: IBarItemView?) -> Self

}
