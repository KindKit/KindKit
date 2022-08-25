//
//  KindKitView
//

import Foundation
import KindKitCore
import KindKitMath

public protocol ISwipeCellView : ICellView {
    
    var isShowedLeadingView: Bool { get }
    
    var leadingSize: Float { set get }
    
    var leadingLimit: Float { set get }
    
    var isShowedTrailingView: Bool { get }
    
    var trailingSize: Float { set get }
    
    var trailingLimit: Float { set get }
    
    var animationVelocity: Float { set get }
    
    func showLeadingView(animated: Bool, completion: (() -> Void)?)
    
    func hideLeadingView(animated: Bool, completion: (() -> Void)?)
    
    func showTrailingView(animated: Bool, completion: (() -> Void)?)
    
    func hideTrailingView(animated: Bool, completion: (() -> Void)?)
    
    @discardableResult
    func animationVelocity(_ value: Float) -> Self
    
    @discardableResult
    func onShowLeading(_ value: (() -> Void)?) -> Self
    
    @discardableResult
    func onHideLeading(_ value: (() -> Void)?) -> Self
    
    @discardableResult
    func onShowTrailing(_ value: (() -> Void)?) -> Self
    
    @discardableResult
    func onHideTrailing(_ value: (() -> Void)?) -> Self
    
    @discardableResult
    func onPressed(_ value: (() -> Void)?) -> Self
    
}

public extension ISwipeCellView {
    
    @inlinable
    @discardableResult
    func leadingSize(_ value: Float) -> Self {
        self.leadingSize = value
        return self
    }
    
    @inlinable
    @discardableResult
    func leadingLimit(_ value: Float) -> Self {
        self.leadingLimit = value
        return self
    }
    
    @inlinable
    @discardableResult
    func trailingSize(_ value: Float) -> Self {
        self.trailingSize = value
        return self
    }
    
    @inlinable
    @discardableResult
    func trailingLimit(_ value: Float) -> Self {
        self.trailingLimit = value
        return self
    }
    
    @inlinable
    @discardableResult
    func animationVelocity(_ value: Float) -> Self {
        self.animationVelocity = value
        return self
    }
    
    @inlinable
    func showLeadingView(animated: Bool = true, completion: (() -> Void)? = nil) {
        self.showLeadingView(animated: animated, completion: completion)
    }
    
    @inlinable
    func hideLeadingView(animated: Bool = true, completion: (() -> Void)? = nil) {
        self.hideLeadingView(animated: animated, completion: completion)
    }
    
    @inlinable
    func showTrailingView(animated: Bool = true, completion: (() -> Void)? = nil) {
        self.showTrailingView(animated: animated, completion: completion)
    }
    
    @inlinable
    func hideTrailingView(animated: Bool = true, completion: (() -> Void)? = nil) {
        self.hideTrailingView(animated: animated, completion: completion)
    }
    
}
