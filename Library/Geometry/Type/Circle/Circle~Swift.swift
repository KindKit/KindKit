//
//  KindKit
//

extension Circle : Comparable {
    
    @inlinable
    public static func < (lhs: Self, rhs: Self) -> Bool {
        return lhs.origin < rhs.origin && lhs.radius < rhs.radius
    }
    
    @inlinable
    public static func > (lhs: Self, rhs: Self) -> Bool {
        return lhs.origin > rhs.origin && lhs.radius > rhs.radius
    }
    
    @inlinable
    public static func <= (lhs: Self, rhs: Self) -> Bool {
        return lhs.origin <= rhs.origin && lhs.radius <= rhs.radius
    }
    
    @inlinable
    public static func >= (lhs: Self, rhs: Self) -> Bool {
        return lhs.origin >= rhs.origin && lhs.radius >= rhs.radius
    }
    
}
