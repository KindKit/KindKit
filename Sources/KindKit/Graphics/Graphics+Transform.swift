//
//  KindKit
//

import Foundation

public extension Graphics {

    struct Transform : Hashable {
        
        public var translation: Point
        public var rotation: Angle
        public var scale: Point
        
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
    
}

public extension Graphics.Transform {
    
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
        var result = Matrix3.identity
        if self.isScaled == true {
            result = Matrix3(scale: self.scale) * result
        }
        if self.isRotated == true {
            result = Matrix3(rotation: self.rotation) * result
        }
        if self.isTranslated == true {
            result = Matrix3(translation: self.translation) * result
        }
        return result
    }
    
}
