//
//  KindKit
//

extension Size : Comparable {
    
    @inlinable
    public static func < (lhs: Self, rhs: Self) -> Bool {
        return lhs.width < rhs.width && lhs.height < rhs.height
    }
    
    @inlinable
    public static func > (lhs: Self, rhs: Self) -> Bool {
        return lhs.width > rhs.width && lhs.height > rhs.height
    }
    
    @inlinable
    public static func <= (lhs: Self, rhs: Self) -> Bool {
        return lhs.width <= rhs.width && lhs.height <= rhs.height
    }
    
    @inlinable
    public static func >= (lhs: Self, rhs: Self) -> Bool {
        return lhs.width >= rhs.width && lhs.height >= rhs.height
    }
    
}
