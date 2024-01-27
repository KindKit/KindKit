//
//  KindKit
//

extension Inset : Comparable {
    
    @inlinable
    public static func < (lhs: Self, rhs: Self) -> Bool {
        return lhs.top < rhs.top && lhs.left < rhs.left && lhs.right < rhs.right && lhs.bottom < rhs.bottom
    }
    
    @inlinable
    public static func > (lhs: Self, rhs: Self) -> Bool {
        return lhs.top > rhs.top && lhs.left > rhs.left && lhs.right > rhs.right && lhs.bottom > rhs.bottom
    }
    
    @inlinable
    public static func <= (lhs: Self, rhs: Self) -> Bool {
        return lhs.top <= rhs.top && lhs.left <= rhs.left && lhs.right <= rhs.right && lhs.bottom <= rhs.bottom
    }
    
    @inlinable
    public static func >= (lhs: Self, rhs: Self) -> Bool {
        return lhs.top >= rhs.top && lhs.left >= rhs.left && lhs.right >= rhs.right && lhs.bottom >= rhs.bottom
    }
    
}
