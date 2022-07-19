//
//  KindKitView
//

import Foundation
import KindKitCore
import KindKitMath

public protocol IStackBarView : IBarView {
    
    var inset: InsetFloat { set get }
    
    var headerView: IView? { set get }
    
    var headerSpacing: Float { set get }
    
    var leadingViews: [IView] { set get }
    
    var leadingViewSpacing: Float { set get }
    
    var centerView: IView? { set get }
    
    var centerSpacing: Float { set get }
    
    var trailingViews: [IView] { set get }
    
    var trailingViewSpacing: Float { set get }
    
    var footerView: IView? { set get }
    
    var footerSpacing: Float { set get }
    
    @discardableResult
    func inset(_ value: InsetFloat) -> Self
    
    @discardableResult
    func headerView(_ value: IView?) -> Self
    
    @discardableResult
    func headerSpacing(_ value: Float) -> Self
    
    @discardableResult
    func leadingViews(_ value: [IView]) -> Self
    
    @discardableResult
    func leadingViewSpacing(_ value: Float) -> Self
    
    @discardableResult
    func centerView(_ value: IView?) -> Self
    
    @discardableResult
    func centerSpacing(_ value: Float) -> Self
    
    @discardableResult
    func trailingViews(_ value: [IView]) -> Self
    
    @discardableResult
    func trailingViewSpacing(_ value: Float) -> Self
    
    @discardableResult
    func footerView(_ value: IView?) -> Self
    
    @discardableResult
    func footerSpacing(_ value: Float) -> Self

}
