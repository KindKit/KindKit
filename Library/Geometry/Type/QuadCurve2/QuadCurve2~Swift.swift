//
//  KindKit
//

extension QuadCurve2 : Comparable {
    
    @inlinable
    public static func < (lhs: Self, rhs: Self) -> Bool {
        return lhs.start < rhs.start && lhs.control < rhs.control && lhs.end < rhs.end
    }
    
    @inlinable
    public static func > (lhs: Self, rhs: Self) -> Bool {
        return lhs.start > rhs.start && lhs.control > rhs.control && lhs.end > rhs.end
    }
    
    @inlinable
    public static func <= (lhs: Self, rhs: Self) -> Bool {
        return lhs.start <= rhs.start && lhs.control <= rhs.control && lhs.end <= rhs.end
    }
    
    @inlinable
    public static func >= (lhs: Self, rhs: Self) -> Bool {
        return lhs.start >= rhs.start && lhs.control >= rhs.control && lhs.end >= rhs.end
    }
    
}
