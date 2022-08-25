//
//  KindKitView
//

import Foundation
import KindKitCore
import KindKitMath

public protocol ICustomView : IView, IViewDynamicSizeBehavioural, IViewHighlightable, IViewLockable, IViewColorable, IViewBorderable, IViewCornerRadiusable, IViewShadowable, IViewAlphable {
    
    var gestures: [IGesture] { set get }
    
    var contentSize: SizeFloat { get }
    
    var shouldHighlighting: Bool { set get }
    
    @discardableResult
    func gestures(_ value: [IGesture]) -> Self
    
    @discardableResult
    func add(gesture: IGesture) -> Self
    
    @discardableResult
    func remove(gesture: IGesture) -> Self

}

public extension ICustomView {
    
    @inlinable
    @discardableResult
    func shouldHighlighting(_ value: Bool) -> Self {
        self.shouldHighlighting = value
        return self
    }
    
    @inlinable
    @discardableResult
    func gestures(_ value: [IGesture]) -> Self {
        self.gestures = value
        return self
    }
    
}
