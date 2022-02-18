//
//  KindKitView
//

import Foundation
import KindKitCore
import KindKitMath

public struct ViewShadow : Equatable {

    public let color: Color
    public let opacity: Float
    public let radius: Float
    public let offset: PointFloat
    
    @inlinable
    public init(
        color: Color,
        opacity: Float,
        radius: Float,
        offset: PointFloat
    ) {
        self.color = color
        self.opacity = opacity
        self.radius = radius
        self.offset = offset
    }

}

public protocol IViewShadowable : AnyObject {
    
    var shadow: ViewShadow? { set get }
    
    @discardableResult
    func shadow(_ value: ViewShadow?) -> Self
    
}

extension IWidgetView where Body : IViewShadowable {
    
    public var shadow: ViewShadow? {
        set(value) { self.body.shadow = value }
        get { return self.body.shadow }
    }
    
    @discardableResult
    public func shadow(_ value: ViewShadow?) -> Self {
        self.body.shadow(value)
        return self
    }
    
}
