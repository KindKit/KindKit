//
//  KindKitView
//

import Foundation
import KindKitCore
import KindKitMath

public struct GradientViewFill {
    
    public let mode: GradientViewMode
    public let points: [GradientViewPoint]
    public let start: PointFloat
    public let end: PointFloat
    @inlinable
    public var isOpaque: Bool {
        for point in self.points {
            if point.color.isOpaque == false {
                return false
            }
        }
        return true
    }
    
    @inlinable
    public init(
        mode: GradientViewMode,
        points: [GradientViewPoint],
        start: PointFloat,
        end: PointFloat
    ) {
        self.mode = mode
        self.points = points
        self.start = start
        self.end = end
    }
    
}

public enum GradientViewMode {
    
    case axial
    case radial
    
}

public struct GradientViewPoint {
    
    public let color: Color
    public let location: Float
    
    @inlinable
    public init(
        color: Color,
        location: Float
    ) {
        self.color = color
        self.location = location
    }
    
}

public protocol IGradientView : IView, IViewStaticSizeBehavioural, IViewColorable, IViewBorderable, IViewCornerRadiusable, IViewShadowable, IViewAlphable {
    
    var aspectRatio: Float? { set get }
    
    var fill: GradientViewFill { set get }
    
}

public extension IGradientView {
    
    @inlinable
    @discardableResult
    func aspectRatio(_ value: Float?) -> Self {
        self.aspectRatio = value
        return self
    }
    
    @inlinable
    @discardableResult
    func fill(_ value: GradientViewFill) -> Self {
        self.fill = value
        return self
    }
    
}
