//
//  KindKitView
//

import Foundation
import KindKitCore
import KindKitMath

public enum RateViewRounding {
    
    case up
    case down
    
}

public struct RateViewState {
    
    public let image: Image
    public let rate: Float
    
    public init(
        image: Image,
        rate: Float
    ) {
        self.image = image
        self.rate = rate
    }
    
}

public protocol IRateView : IView, IViewColorable, IViewBorderable, IViewCornerRadiusable, IViewShadowable, IViewAlphable {
    
    var itemSize: SizeFloat { set get }
    
    var itemSpacing: Float { set get }
    
    var numberOfItem: UInt { set get }
    
    var rounding: RateViewRounding { set get }
    
    var states: [RateViewState] { set get }
    
    var rating: Float { set get }
    
    @discardableResult
    func itemSize(_ value: SizeFloat) -> Self
    
    @discardableResult
    func itemSpacing(_ value: Float) -> Self
    
    @discardableResult
    func numberOfItem(_ value: UInt) -> Self
    
    @discardableResult
    func rounding(_ value: RateViewRounding) -> Self
    
    @discardableResult
    func states(_ value: [RateViewState]) -> Self
    
    @discardableResult
    func rating(_ value: Float) -> Self
    
}
