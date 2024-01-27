//
//  KindKit
//

extension Segment2 : Comparable {
    
    @inlinable
    public static func < (lhs: Self, rhs: Self) -> Bool {
        return lhs.start < rhs.start && lhs.end < rhs.end
    }
    
    @inlinable
    public static func > (lhs: Self, rhs: Self) -> Bool {
        return lhs.start > rhs.start && lhs.end > rhs.end
    }
    
    @inlinable
    public static func <= (lhs: Self, rhs: Self) -> Bool {
        return lhs.start <= rhs.start && lhs.end <= rhs.end
    }
    
    @inlinable
    public static func >= (lhs: Self, rhs: Self) -> Bool {
        return lhs.start >= rhs.start && lhs.end >= rhs.end
    }
    
}
