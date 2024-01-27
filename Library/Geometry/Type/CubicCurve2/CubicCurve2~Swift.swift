//
//  KindKit
//

extension CubicCurve2 : Comparable {
    
    @inlinable
    public static func < (lhs: Self, rhs: Self) -> Bool {
        return lhs.start < rhs.start && lhs.control1 < rhs.control1 && lhs.control2 < rhs.control2 && lhs.end < rhs.end
    }
    
    @inlinable
    public static func > (lhs: Self, rhs: Self) -> Bool {
        return lhs.start > rhs.start && lhs.control1 > rhs.control1 && lhs.control2 > rhs.control2 && lhs.end > rhs.end
    }
    
    @inlinable
    public static func <= (lhs: Self, rhs: Self) -> Bool {
        return lhs.start <= rhs.start && lhs.control1 <= rhs.control1 && lhs.control2 <= rhs.control2 && lhs.end <= rhs.end
    }
    
    @inlinable
    public static func >= (lhs: Self, rhs: Self) -> Bool {
        return lhs.start >= rhs.start && lhs.control1 >= rhs.control1 && lhs.control2 >= rhs.control2 && lhs.end >= rhs.end
    }
    
}
