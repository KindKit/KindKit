//
//  KindKit
//

extension Pixel : Comparable {
    
    @inlinable
    public static func < (lhs: Self, rhs: Self) -> Bool {
        return lhs.r < rhs.r && lhs.g < rhs.g && lhs.b < rhs.b && lhs.a < rhs.a
    }
    
    @inlinable
    public static func > (lhs: Self, rhs: Self) -> Bool {
        return lhs.r > rhs.r && lhs.g > rhs.g && lhs.b > rhs.b && lhs.a > rhs.a
    }
    
    @inlinable
    public static func <= (lhs: Self, rhs: Self) -> Bool {
        return lhs.r <= rhs.r && lhs.g <= rhs.g && lhs.b <=  rhs.b && lhs.a <=  rhs.a
    }
    
    @inlinable
    public static func >= (lhs: Self, rhs: Self) -> Bool {
        return lhs.r >= rhs.r && lhs.g >= rhs.g && lhs.b >= rhs.b && lhs.a >= rhs.a
    }
    
}
