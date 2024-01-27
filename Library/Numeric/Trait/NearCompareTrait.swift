//
//  KindKit
//

import KindCore

public protocol NearCompareTrait : NearEqualTrait {
    
    func isLess(_ other: Self, tolerance: Self) -> Bool
    
    func isMore(_ other: Self, tolerance: Self) -> Bool
    
    func isLessOrEqual(_ other: Self, tolerance: Self) -> Bool
    
    func isMoreOrEqual(_ other: Self, tolerance: Self) -> Bool
    
}

public extension NearCompareTrait {
    
    func isMore(_ other: Self, tolerance: Self) -> Bool {
        return other.isLess(self, tolerance: tolerance)
    }
    
    func isMoreOrEqual(_ other: Self, tolerance: Self) -> Bool {
        return other.isLessOrEqual(self, tolerance: tolerance)
    }
    
}

public extension NearCompareTrait where Self : EpsilonTrait {
    
    @inlinable
    func isNearLess(_ other: Self) -> Bool {
        return self.isLess(other, tolerance: .epsilon)
    }
    
    @inlinable
    func isNearMore(_ other: Self) -> Bool {
        return self.isMore(other, tolerance: .epsilon)
    }
    
    @inlinable
    func isNearLessOrEqual(_ other: Self) -> Bool {
        return self.isLessOrEqual(other, tolerance: .epsilon)
    }
    
    @inlinable
    func isNearMoreOrEqual(_ other: Self) -> Bool {
        return self.isMoreOrEqual(other, tolerance: .epsilon)
    }
    
}

public extension NearCompareTrait where Self : Comparable & AddTrait & SubTrait {
    
    func isLess(_ other: Self, tolerance: Self) -> Bool {
        return (self - tolerance).isLess(other)
    }
    
    func isMore(_ other: Self, tolerance: Self) -> Bool {
        return (self + tolerance).isMore(other)
    }
    
    func isLessOrEqual(_ other: Self, tolerance: Self) -> Bool {
        let anchor = self - tolerance
        if anchor.isLess(other) {
            return true
        }
        return self.isEqual(other, tolerance: tolerance)
    }
    
    func isMoreOrEqual(_ other: Self, tolerance: Self) -> Bool {
        let anchor = self + tolerance
        if anchor.isMore(other) {
            return true
        }
        return self.isEqual(other, tolerance: tolerance)
    }
    
}
