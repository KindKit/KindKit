//
//  KindKit
//

extension AlignedBox2 : Comparable {
    
    @inlinable
    public static func < (lhs: Self, rhs: Self) -> Bool {
        return lhs.lower < rhs.lower && lhs.upper < rhs.upper
    }
    
    @inlinable
    public static func > (lhs: Self, rhs: Self) -> Bool {
        return lhs.lower > rhs.lower && lhs.upper > rhs.upper
    }
    
    @inlinable
    public static func <= (lhs: Self, rhs: Self) -> Bool {
        return lhs.lower <= rhs.lower && lhs.upper <= rhs.upper
    }
    
    @inlinable
    public static func >= (lhs: Self, rhs: Self) -> Bool {
        return lhs.lower >= rhs.lower && lhs.upper >= rhs.upper
    }
    
}
