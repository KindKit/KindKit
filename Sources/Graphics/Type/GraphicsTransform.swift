//
//  KindKitGraphics
//

import Foundation
import KindKitCore
import KindKitMath

public struct GraphicsTransform : Hashable {
    
    public var translation: PointFloat
    public var rotation: AngleFloat
    public var scale: PointFloat
    
    @inlinable
    public init(
        translation: PointFloat = .zero,
        rotation: AngleFloat = .degrees0,
        scale: PointFloat = .one
    ) {
        self.translation = translation
        self.rotation = rotation
        self.scale = scale
    }
    
}

public extension GraphicsTransform {
    
    @inlinable
    var matrix: Matrix3Float {
        var result = Matrix3Float.identity
        if self.scale.isOne == false {
            result = Matrix3Float(scale: self.scale) * result
        }
        if self.rotation !~ .degrees0 {
            result = Matrix3Float(rotation: self.rotation) * result
        }
        if self.translation.isZero == false {
            result = Matrix3Float(translation: self.translation) * result
        }
        return result
    }
    
}
