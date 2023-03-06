//
//  KindKit
//

import Foundation
import CoreGraphics

public struct Matrix3 : Hashable {
    
    public var m11: Double
    public var m12: Double
    public var m13: Double
    public var m21: Double
    public var m22: Double
    public var m23: Double
    public var m31: Double
    public var m32: Double
    public var m33: Double
    
    public init(
        _ m11: Double, _ m12: Double, _ m13: Double,
        _ m21: Double, _ m22: Double, _ m23: Double,
        _ m31: Double, _ m32: Double, _ m33: Double
    ) {
        self.m11 = m11; self.m12 = m12; self.m13 = m13
        self.m21 = m21; self.m22 = m22; self.m23 = m23
        self.m31 = m31; self.m32 = m32; self.m33 = m33
    }
    
    public init(translation: Point) {
        self.init(
            1, 0, 0,
            0, 1, 0,
            translation.x, translation.y, 1
        )
    }
    
    public init(rotation: Angle) {
        let radians = rotation.radians
        let cs = radians.cos
        let sn = radians.sin
        self.init(
            cs, sn, 0,
            -sn, cs, 0,
            0, 0, 1
        )
    }
    
    public init(scale: Point) {
        self.init(
            scale.x, 0, 0,
            0, scale.y, 0,
            0, 0, 1
        )
    }
    
}

public extension Matrix3 {
    
    @inlinable
    static var identity: Self {
        return Matrix3(1, 0, 0, 0, 1, 0, 0, 0, 1)
    }
    
}

public extension Matrix3 {
    
    @inlinable
    var isIdentity: Bool {
        guard self ~~ .identity else { return false }
        return true
    }
    
}

public extension Matrix3 {
    
    @inlinable
    var adjugate: Self {
        return Matrix3(
            self.m22 * self.m33 - self.m23 * self.m32,
            self.m13 * self.m32 - self.m12 * self.m33,
            self.m12 * self.m23 - self.m13 * self.m22,
            self.m23 * self.m31 - self.m21 * self.m33,
            self.m11 * self.m33 - self.m13 * self.m31,
            self.m13 * self.m21 - self.m11 * self.m23,
            self.m21 * self.m32 - self.m22 * self.m31,
            self.m12 * self.m31 - self.m11 * self.m32,
            self.m11 * self.m22 - self.m12 * self.m21
        )
    }
    
    @inlinable
    var determinant: Double {
        let a = self.m11 * self.m22 * self.m33 + self.m12 * self.m23 * self.m31 + self.m13 * self.m21 * self.m32
        let b = self.m13 * self.m22 * self.m31 + self.m11 * self.m23 * self.m32 + self.m12 * self.m21 * self.m33
        return a - b
    }
    
    @inlinable
    var transpose: Self {
        return Matrix3(
            self.m11, self.m21, self.m31,
            self.m12, self.m22, self.m32,
            self.m13, self.m23, self.m33
        )
    }
    
    @inlinable
    var inverse: Self {
        return self.adjugate * (1 / self.determinant)
    }
    
}

public extension Matrix3 {
    
    @inlinable
    static prefix func - (m: Self) -> Self {
        return m.inverse
    }
    
    @inlinable
    static func * (lhs: Self, rhs: Self) -> Self {
        return Matrix3(
            lhs.m11 * rhs.m11 + lhs.m21 * rhs.m12 + lhs.m31 * rhs.m13,
            lhs.m12 * rhs.m11 + lhs.m22 * rhs.m12 + lhs.m32 * rhs.m13,
            lhs.m13 * rhs.m11 + lhs.m23 * rhs.m12 + lhs.m33 * rhs.m13,
            lhs.m11 * rhs.m21 + lhs.m21 * rhs.m22 + lhs.m31 * rhs.m23,
            lhs.m12 * rhs.m21 + lhs.m22 * rhs.m22 + lhs.m32 * rhs.m23,
            lhs.m13 * rhs.m21 + lhs.m23 * rhs.m22 + lhs.m33 * rhs.m23,
            lhs.m11 * rhs.m31 + lhs.m21 * rhs.m32 + lhs.m31 * rhs.m33,
            lhs.m12 * rhs.m31 + lhs.m22 * rhs.m32 + lhs.m32 * rhs.m33,
            lhs.m13 * rhs.m31 + lhs.m23 * rhs.m32 + lhs.m33 * rhs.m33
        )
    }
    
    @inlinable
    static func * (lhs: Self, rhs: Double) -> Self {
        return Matrix3(
            lhs.m11 * rhs, lhs.m12 * rhs, lhs.m13 * rhs,
            lhs.m21 * rhs, lhs.m22 * rhs, lhs.m23 * rhs,
            lhs.m31 * rhs, lhs.m32 * rhs, lhs.m33 * rhs
        )
    }
    
    @inlinable
    static func *= (lhs: inout Self, rhs: Self) {
        lhs = lhs * rhs
    }
    
    @inlinable
    static func *= (lhs: inout Self, rhs: Double) {
        lhs = lhs * rhs
    }
    
}

extension Matrix3 : INearEqutable {
    
    @inlinable
    public static func ~~ (lhs: Self, rhs: Self) -> Bool {
        return lhs.m11 ~~ rhs.m11 && lhs.m12 ~~ rhs.m12 && lhs.m13 ~~ rhs.m13 &&
            lhs.m21 ~~ rhs.m21 && lhs.m22 ~~ rhs.m22 && lhs.m23 ~~ rhs.m23 &&
            lhs.m31 ~~ rhs.m31 && lhs.m32 ~~ rhs.m32 && lhs.m33 ~~ rhs.m33
    }
    
    @inlinable
    public static func <~ (lhs: Self, rhs: Self) -> Bool {
        return lhs.m11 <~ rhs.m11 && lhs.m12 <~ rhs.m12 && lhs.m13 <~ rhs.m13 &&
            lhs.m21 <~ rhs.m21 && lhs.m22 <~ rhs.m22 && lhs.m23 <~ rhs.m23 &&
            lhs.m31 <~ rhs.m31 && lhs.m32 <~ rhs.m32 && lhs.m33 <~ rhs.m33
    }
    
    @inlinable
    public static func >~ (lhs: Self, rhs: Self) -> Bool {
        return lhs.m11 >~ rhs.m11 && lhs.m12 >~ rhs.m12 && lhs.m13 >~ rhs.m13 &&
            lhs.m21 >~ rhs.m21 && lhs.m22 >~ rhs.m22 && lhs.m23 >~ rhs.m23 &&
            lhs.m31 >~ rhs.m31 && lhs.m32 >~ rhs.m32 && lhs.m33 >~ rhs.m33
    }
    
}

extension Matrix3 : ILerpable {
    
    @inlinable
    public func lerp(_ to: Self, progress: Percent) -> Self {
        let m11 = self.m11.lerp(to.m11, progress: progress)
        let m12 = self.m12.lerp(to.m12, progress: progress)
        let m13 = self.m13.lerp(to.m13, progress: progress)
        let m21 = self.m21.lerp(to.m21, progress: progress)
        let m22 = self.m22.lerp(to.m22, progress: progress)
        let m23 = self.m23.lerp(to.m23, progress: progress)
        let m31 = self.m31.lerp(to.m31, progress: progress)
        let m32 = self.m32.lerp(to.m32, progress: progress)
        let m33 = self.m33.lerp(to.m33, progress: progress)
        return Matrix3(m11, m12, m13, m21, m22, m23, m31, m32, m33)
    }
    
}
