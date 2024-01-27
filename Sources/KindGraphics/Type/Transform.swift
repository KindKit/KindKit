//
//  KindKit
//

import KindMath
import KindMonadicMacro

@KindMonadic
public struct Transform : Hashable {

    @KindMonadicProperty
    public let translation: Point
    
    @KindMonadicProperty
    public let rotation: Angle
    
    @KindMonadicProperty
    public let scale: Point
    
    public init(
        translation: Point = .zero,
        rotation: Angle = .degrees0,
        scale: Point = .one
    ) {
        self.translation = translation
        self.rotation = rotation
        self.scale = scale
    }
    
}

public extension Transform {
    
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
    var matrix: Matrix3 {
        return .init(
            translation: self.translation,
            rotation: self.rotation,
            scale: self.scale
        )
    }
    
}

extension Transform : ILerpable {
    
    @inlinable
    public func lerp(_ to: Self, progress: Percent) -> Self {
        return .init(
            translation: self.translation.lerp(to.translation, progress: progress),
            rotation: self.rotation.lerp(to.rotation, progress: progress),
            scale: self.scale.lerp(to.scale, progress: progress)
        )
    }
    
}
