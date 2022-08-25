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
    
}

public extension IRateView {
    
    @inlinable
    @discardableResult
    func itemSize(_ value: SizeFloat) -> Self {
        self.itemSize = value
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
    func numberOfItem(_ value: UInt) -> Self {
        self.numberOfItem = value
        return self
    }
    
    @inlinable
    @discardableResult
    func rounding(_ value: RateViewRounding) -> Self {
        self.rounding = value
        return self
    }
    
    @inlinable
    @discardableResult
    func states(_ value: [RateViewState]) -> Self {
        self.states = value
        return self
    }
    
    @inlinable
    @discardableResult
    func rating(_ value: Float) -> Self {
        self.rating = value
        return self
    }
    
}
