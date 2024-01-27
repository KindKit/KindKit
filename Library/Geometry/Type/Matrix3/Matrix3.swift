//
//  KindKit
//

import KindNumeric

public struct Matrix3 : Hashable, Equatable {
    
    public var m11: Coordinate
    public var m12: Coordinate
    public var m13: Coordinate
    public var m21: Coordinate
    public var m22: Coordinate
    public var m23: Coordinate
    public var m31: Coordinate
    public var m32: Coordinate
    public var m33: Coordinate
    
    public init(
        _ m11: Coordinate, _ m12: Coordinate, _ m13: Coordinate,
        _ m21: Coordinate, _ m22: Coordinate, _ m23: Coordinate,
        _ m31: Coordinate, _ m32: Coordinate, _ m33: Coordinate
    ) {
        self.m11 = m11
        self.m12 = m12
        self.m13 = m13
        self.m21 = m21
        self.m22 = m22
        self.m23 = m23
        self.m31 = m31
        self.m32 = m32
        self.m33 = m33
    }
    
    public init(
        _ all: Coordinate
    ) {
        self.m11 = all
        self.m12 = all
        self.m13 = all
        self.m21 = all
        self.m22 = all
        self.m23 = all
        self.m31 = all
        self.m32 = all
        self.m33 = all
    }
    
}

public extension Matrix3{
    
    @inlinable
    static var identity: Self {
        return .init(
            .one, .zero, .zero,
            .zero, .one, .zero,
            .zero, .zero, .one
        )
    }
    
    @inlinable
    var isIdentity: Bool {
        return self.isNearEqual(.identity)
    }
    
    @inlinable
    var transpose: Self {
        return .init(
            self.m11, self.m21, self.m31,
            self.m12, self.m22, self.m32,
            self.m13, self.m23, self.m33
        )
    }
    
    @inlinable
    var adjugate: Self {
        let m11 = (self.m22 * self.m33) - (self.m23 * self.m32)
        let m12 = (self.m13 * self.m32) - (self.m12 * self.m33)
        let m13 = (self.m12 * self.m23) - (self.m13 * self.m22)
        let m21 = (self.m23 * self.m31) - (self.m21 * self.m33)
        let m22 = (self.m11 * self.m33) - (self.m13 * self.m31)
        let m23 = (self.m13 * self.m21) - (self.m11 * self.m23)
        let m31 = (self.m21 * self.m32) - (self.m22 * self.m31)
        let m32 = (self.m12 * self.m31) - (self.m11 * self.m32)
        let m33 = (self.m11 * self.m22) - (self.m12 * self.m21)
        return .init(
            m11, m12, m13,
            m21, m22, m23,
            m31, m32, m33
        )
    }
    
    @inlinable
    var determinant: Coordinate {
        let a1 = self.m11 * self.m22 * self.m33
        let a2 = self.m12 * self.m23 * self.m31
        let a3 = self.m13 * self.m21 * self.m32
        let a = a1 + a2 + a3
        let b1 = self.m13 * self.m22 * self.m31
        let b2 = self.m11 * self.m23 * self.m32
        let b3 = self.m12 * self.m21 * self.m33
        let b = b1 + b2 + b3
        return a - b
    }
    
}

public extension Matrix3{
    
    @inlinable
    init(translation: Point) {
        self.init(
            .one, .zero, .zero,
            .zero, .one, .zero,
            translation.x, translation.y, .one
        )
    }
    
    @inlinable
    init(rotation: Radian) {
        let cs = Coordinate(rotation.cos.value)
        let sn = Coordinate(rotation.sin.value)
        self.init(
            cs, sn, .zero,
            -sn, cs, .zero,
            .zero, .zero, .one
        )
    }
    
    @inlinable
    init(scale: Point) {
        self.init(
            scale.x, .zero, .zero,
            .zero, scale.y, .zero,
            .zero, .zero, .one
        )
    }
    
    @inlinable
    init(scale: Coordinate) {
        self.init(
            scale, .zero, .zero,
            .zero, scale, .zero,
            .zero, .zero, .one
        )
    }
    
    @inlinable
    init(
        translation: Point,
        rotation: Radian,
        scale: Point
    ) {
        var result = Self.identity
        if scale.isNotOne {
            result = Matrix3(scale: scale).multiplying(by: result)
        }
        if rotation.isNotZero {
            result = Matrix3(rotation: rotation).multiplying(by: result)
        }
        if translation.isNotZero {
            result = Matrix3(translation: translation).multiplying(by: result)
        }
        self = result
    }
    
    @inlinable
    init(
        translation: Point,
        rotation: Radian,
        scale: Coordinate
    ) {
        self.init(
            translation: translation,
            rotation: rotation,
            scale: .init(both: scale)
        )
    }
    
}
