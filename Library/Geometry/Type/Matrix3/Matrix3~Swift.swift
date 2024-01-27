//
//  KindKit
//

extension Matrix3 : Comparable {
    
    @inlinable
    public static func < (lhs: Self, rhs: Self) -> Bool {
        return lhs.m11 < rhs.m11
            && lhs.m12 < rhs.m12
            && lhs.m13 < rhs.m13
            && lhs.m21 < rhs.m21
            && lhs.m22 < rhs.m22
            && lhs.m23 < rhs.m23
            && lhs.m31 < rhs.m31
            && lhs.m32 < rhs.m32
            && lhs.m33 < rhs.m33
    }
    
    @inlinable
    public static func > (lhs: Self, rhs: Self) -> Bool {
        return lhs.m11 > rhs.m11
            && lhs.m12 > rhs.m12
            && lhs.m13 > rhs.m13
            && lhs.m21 > rhs.m21
            && lhs.m22 > rhs.m22
            && lhs.m23 > rhs.m23
            && lhs.m31 > rhs.m31
            && lhs.m32 > rhs.m32
            && lhs.m33 > rhs.m33
    }
    
    @inlinable
    public static func <= (lhs: Self, rhs: Self) -> Bool {
        return lhs.m11 <= rhs.m11
            && lhs.m12 <= rhs.m12
            && lhs.m13 <= rhs.m13
            && lhs.m21 <= rhs.m21
            && lhs.m22 <= rhs.m22
            && lhs.m23 <= rhs.m23
            && lhs.m31 <= rhs.m31
            && lhs.m32 <= rhs.m32
            && lhs.m33 <= rhs.m33
    }
    
    @inlinable
    public static func >= (lhs: Self, rhs: Self) -> Bool {
        return lhs.m11 >= rhs.m11
            && lhs.m12 >= rhs.m12
            && lhs.m13 >= rhs.m13
            && lhs.m21 >= rhs.m21
            && lhs.m22 >= rhs.m22
            && lhs.m23 >= rhs.m23
            && lhs.m31 >= rhs.m31
            && lhs.m32 >= rhs.m32
            && lhs.m33 >= rhs.m33
    }
    
}
