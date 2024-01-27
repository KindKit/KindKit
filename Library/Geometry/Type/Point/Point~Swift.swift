//
//  KindKit
//

extension Point : Comparable {
    
    @inlinable
    public static func < (lhs: Self, rhs: Self) -> Bool {
        return lhs.x < rhs.x && lhs.y < rhs.y
    }
    
    @inlinable
    public static func > (lhs: Self, rhs: Self) -> Bool {
        return lhs.x > rhs.x && lhs.y > rhs.y
    }
    
    @inlinable
    public static func <= (lhs: Self, rhs: Self) -> Bool {
        return lhs.x <= rhs.x && lhs.y <= rhs.y
    }
    
    @inlinable
    public static func >= (lhs: Self, rhs: Self) -> Bool {
        return lhs.x >= rhs.x && lhs.y >= rhs.y
    }
    
}
