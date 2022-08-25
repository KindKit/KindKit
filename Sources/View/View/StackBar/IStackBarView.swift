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
    
    var centerFilling: Bool { set get }
    
    var centerSpacing: Float { set get }
    
    var trailingViews: [IView] { set get }
    
    var trailingViewSpacing: Float { set get }
    
    var footerView: IView? { set get }
    
    var footerSpacing: Float { set get }

}

public extension IStackBarView {
    
    @inlinable
    @discardableResult
    func inset(_ value: InsetFloat) -> Self {
        self.inset = value
        return self
    }
    
    @inlinable
    @discardableResult
    func headerView(_ value: IView?) -> Self {
        self.headerView = value
        return self
    }
    
    @inlinable
    @discardableResult
    func headerSpacing(_ value: Float) -> Self {
        self.headerSpacing = value
        return self
    }
    
    @inlinable
    @discardableResult
    func leadingViews(_ value: [IView]) -> Self {
        self.leadingViews = value
        return self
    }
    
    @inlinable
    @discardableResult
    func leadingViewSpacing(_ value: Float) -> Self {
        self.leadingViewSpacing = value
        return self
    }
    
    @inlinable
    @discardableResult
    func centerView(_ value: IView?) -> Self {
        self.centerView = value
        return self
    }
    
    @inlinable
    @discardableResult
    func centerFilling(_ value: Bool) -> Self {
        self.centerFilling = value
        return self
    }
    
    @inlinable
    @discardableResult
    func centerSpacing(_ value: Float) -> Self {
        self.centerSpacing = value
        return self
    }
    
    @inlinable
    @discardableResult
    func trailingViews(_ value: [IView]) -> Self {
        self.trailingViews = value
        return self
    }
    
    @inlinable
    @discardableResult
    func trailingViewSpacing(_ value: Float) -> Self {
        self.trailingViewSpacing = value
        return self
    }
    
    @inlinable
    @discardableResult
    func footerView(_ value: IView?) -> Self {
        self.footerView = value
        return self
    }
    
    @inlinable
    @discardableResult
    func footerSpacing(_ value: Float) -> Self {
        self.footerSpacing = value
        return self
    }
    
}
