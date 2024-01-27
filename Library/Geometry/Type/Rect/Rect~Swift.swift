//
//  KindKit
//

extension Rect : Comparable {
    
    @inlinable
    public static func < (lhs: Self, rhs: Self) -> Bool {
        return lhs.origin < rhs.origin && lhs.size < rhs.size
    }
    
    @inlinable
    public static func > (lhs: Self, rhs: Self) -> Bool {
        return lhs.origin > rhs.origin && lhs.size > rhs.size
    }
    
    @inlinable
    public static func <= (lhs: Self, rhs: Self) -> Bool {
        return lhs.origin <= rhs.origin && lhs.size <= rhs.size
    }
    
    @inlinable
    public static func >= (lhs: Self, rhs: Self) -> Bool {
        return lhs.origin >= rhs.origin && lhs.size >= rhs.size
    }
    
}
