//
//  KindKit
//

import KindGeometry
import KindMonadicMacro

@Monadic
public struct Transform {

    @MonadicField
    public let translation: Point
    
    @MonadicField
    public let rotation: Radian
    
    @MonadicField
    public let scale: Point
    
    public init(
        translation: Point = .zero,
        rotation: Radian = .zero,
        scale: Point = .one
    ) {
        self.translation = translation
        self.rotation = rotation
        self.scale = scale
    }
    
}

extension Transform : Hashable {
}

extension Transform : Equatable {
}

extension Transform : Sendable {
}

public extension Transform {
    
    @inlinable
    var isTranslated: Bool {
        return self.translation.isNotZero
    }
    
    @inlinable
    var isRotated: Bool {
        return self.rotation.isNotZero
    }
    
    @inlinable
    var isScaled: Bool {
        return self.scale.isNotOne
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

extension Transform : LerpTrait {
    
    @inlinable
    public func lerp(_ to: Self, by progress: Percent) -> Self {
        return .init(
            translation: self.translation.lerp(to.translation, by: progress),
            rotation: self.rotation.lerp(to.rotation, by: progress),
            scale: self.scale.lerp(to.scale, by: progress)
        )
    }
    
}
