//
//  KindKit
//

extension Line2 : Comparable {
    
    @inlinable
    public static func < (lhs: Self, rhs: Self) -> Bool {
        return lhs.origin < rhs.origin && lhs.direction < rhs.direction
    }
    
    @inlinable
    public static func > (lhs: Self, rhs: Self) -> Bool {
        return lhs.origin > rhs.origin && lhs.direction > rhs.direction
    }
    
    @inlinable
    public static func <= (lhs: Self, rhs: Self) -> Bool {
        return lhs.origin <= rhs.origin && lhs.direction <= rhs.direction
    }
    
    @inlinable
    public static func >= (lhs: Self, rhs: Self) -> Bool {
        return lhs.origin >= rhs.origin && lhs.direction >= rhs.direction
    }
    
}
