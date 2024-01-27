//
//  KindKit
//

extension OrientedBox2 : Comparable {
    
    @inlinable
    public static func < (lhs: Self, rhs: Self) -> Bool {
        return lhs.shape < rhs.shape && lhs.angle < rhs.angle
    }
    
    @inlinable
    public static func > (lhs: Self, rhs: Self) -> Bool {
        return lhs.shape > rhs.shape && lhs.angle > rhs.angle
    }
    
    @inlinable
    public static func <= (lhs: Self, rhs: Self) -> Bool {
        return lhs.shape <= rhs.shape && lhs.angle <= rhs.angle
    }
    
    @inlinable
    public static func >= (lhs: Self, rhs: Self) -> Bool {
        return lhs.shape >= rhs.shape && lhs.angle >= rhs.angle
    }
    
}
