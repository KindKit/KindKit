//
//  KindKit
//

import KindNumeric

extension Matrix3 : EpsilonTrait {
    
    @inlinable
    public static var epsilon: Self {
        return .init(.epsilon)
    }
    
}

extension Matrix3 : InvertTrait {
    
    @inlinable
    public var invert: Self {
        return self.adjugate * Percent(Coordinate.zero, from: self.determinant)
    }
    
}

extension Matrix3 : MulTrait {
    
    @inlinable
    public func doubled() -> Self {
        return .init(
            self.m11.doubled(), self.m12.doubled(), self.m13.doubled(),
            self.m21.doubled(), self.m22.doubled(), self.m23.doubled(),
            self.m31.doubled(), self.m32.doubled(), self.m33.doubled()
        )
    }
    
    @inlinable
    public func multiplying(by other: Self) -> Self {
        let m11 = (self.m11 * other.m11) + (self.m21 * other.m12) + (self.m31 * other.m13)
        let m12 = (self.m12 * other.m11) + (self.m22 * other.m12) + (self.m32 * other.m13)
        let m13 = (self.m13 * other.m11) + (self.m23 * other.m12) + (self.m33 * other.m13)
        let m21 = (self.m11 * other.m21) + (self.m21 * other.m22) + (self.m31 * other.m23)
        let m22 = (self.m12 * other.m21) + (self.m22 * other.m22) + (self.m32 * other.m23)
        let m23 = (self.m13 * other.m21) + (self.m23 * other.m22) + (self.m33 * other.m23)
        let m31 = (self.m11 * other.m31) + (self.m21 * other.m32) + (self.m31 * other.m33)
        let m32 = (self.m12 * other.m31) + (self.m22 * other.m32) + (self.m32 * other.m33)
        let m33 = (self.m13 * other.m31) + (self.m23 * other.m32) + (self.m33 * other.m33)
        return .init(
            m11, m12, m13,
            m21, m22, m23,
            m31, m32, m33
        )
    }
    
}

extension Matrix3 : MulPercentTrait {
    
    @inlinable
    public func multiplying(by other: Percent) -> Self {
        return .init(
            self.m11.multiplying(by: other),
            self.m12.multiplying(by: other),
            self.m13.multiplying(by: other),
            self.m21.multiplying(by: other),
            self.m22.multiplying(by: other),
            self.m23.multiplying(by: other),
            self.m31.multiplying(by: other),
            self.m32.multiplying(by: other),
            self.m33.multiplying(by: other)
        )
    }
    
}

extension Matrix3 : NearCompareTrait {
    
    @inlinable
    public func isLess(_ other: Self, tolerance: Self) -> Bool {
        return self.m11.isLess(other.m11, tolerance: tolerance.m11)
            && self.m12.isLess(other.m12, tolerance: tolerance.m12)
            && self.m13.isLess(other.m13, tolerance: tolerance.m13)
            && self.m21.isLess(other.m21, tolerance: tolerance.m21)
            && self.m22.isLess(other.m22, tolerance: tolerance.m22)
            && self.m23.isLess(other.m23, tolerance: tolerance.m23)
            && self.m31.isLess(other.m31, tolerance: tolerance.m31)
            && self.m32.isLess(other.m32, tolerance: tolerance.m32)
            && self.m33.isLess(other.m33, tolerance: tolerance.m33)
    }
    
    @inlinable
    public func isLessOrEqual(_ other: Self, tolerance: Self) -> Bool {
        return self.m11.isLessOrEqual(other.m11, tolerance: tolerance.m11)
            && self.m12.isLessOrEqual(other.m12, tolerance: tolerance.m12)
            && self.m13.isLessOrEqual(other.m13, tolerance: tolerance.m13)
            && self.m21.isLessOrEqual(other.m21, tolerance: tolerance.m21)
            && self.m22.isLessOrEqual(other.m22, tolerance: tolerance.m22)
            && self.m23.isLessOrEqual(other.m23, tolerance: tolerance.m23)
            && self.m31.isLessOrEqual(other.m31, tolerance: tolerance.m31)
            && self.m32.isLessOrEqual(other.m32, tolerance: tolerance.m32)
            && self.m33.isLessOrEqual(other.m33, tolerance: tolerance.m33)
    }
    
}

extension Matrix3 : NearEqualTrait {
    
    @inlinable
    public func isEqual(_ other: Self, tolerance: Self) -> Bool {
        return self.m11.isEqual(other.m11, tolerance: tolerance.m11)
            && self.m12.isEqual(other.m12, tolerance: tolerance.m12)
            && self.m13.isEqual(other.m13, tolerance: tolerance.m13)
            && self.m21.isEqual(other.m21, tolerance: tolerance.m21)
            && self.m22.isEqual(other.m22, tolerance: tolerance.m22)
            && self.m23.isEqual(other.m23, tolerance: tolerance.m23)
            && self.m31.isEqual(other.m31, tolerance: tolerance.m31)
            && self.m32.isEqual(other.m32, tolerance: tolerance.m32)
            && self.m33.isEqual(other.m33, tolerance: tolerance.m33)
    }
    
}

extension Matrix3 : LerpTrait {
    
    @inlinable
    public func lerp(_ to: Self, by progress: Percent) -> Self {
        return .init(
            self.m11.lerp(to.m11, by: progress),
            self.m12.lerp(to.m12, by: progress),
            self.m13.lerp(to.m13, by: progress),
            self.m21.lerp(to.m21, by: progress),
            self.m22.lerp(to.m22, by: progress),
            self.m23.lerp(to.m23, by: progress),
            self.m31.lerp(to.m31, by: progress),
            self.m32.lerp(to.m32, by: progress),
            self.m33.lerp(to.m33, by: progress)
        )
    }
    
}
