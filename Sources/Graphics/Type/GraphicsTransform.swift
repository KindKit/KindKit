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
    var isTranslated: Bool {
        return self.translation.isZero == false
    }
    
    @inlinable
    var isRotated: Bool {
        return self.rotation !~ .degrees0
    }
    
    @inlinable
    var isScaled: Bool {
        return self.scale.isOne == false
    }
    
    @inlinable
    var matrix: Matrix3Float {
        var result = Matrix3Float.identity
        if self.isScaled == true {
            result = Matrix3Float(scale: self.scale) * result
        }
        if self.isRotated == true {
            result = Matrix3Float(rotation: self.rotation) * result
        }
        if self.isTranslated == true {
            result = Matrix3Float(translation: self.translation) * result
        }
        return result
    }
    
}
