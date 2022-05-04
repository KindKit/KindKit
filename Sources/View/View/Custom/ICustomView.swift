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
    
    @discardableResult
    func shouldHighlighting(_ value: Bool) -> Self

}
