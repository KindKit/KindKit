//
//  KindKit
//

import KindCore

public protocol NearEqualTrait {
    
    func isEqual(_ other: Self, tolerance: Self) -> Bool
    
}

public extension NearEqualTrait {
    
    @inlinable
    func isNotEqual(_ other: Self, tolerance: Self) -> Bool {
        return self.isEqual(other, tolerance: tolerance) == false
    }
    
}

public extension NearEqualTrait where Self : EpsilonTrait {
    
    @inlinable
    func isNearEqual(_ other: Self) -> Bool {
        return self.isEqual(other, tolerance: .epsilon)
    }
    
    @inlinable
    func isNearNotEqual(_ other: Self) -> Bool {
        return self.isNotEqual(other, tolerance: .epsilon)
    }
    
}

public extension NearEqualTrait where Self : Comparable & SubTrait {
    
    func isEqual(_ other: Self, tolerance: Self) -> Bool {
        let diff: Self
        if self.isMore(other) {
            diff = self - other
        } else {
            diff = other - self
        }
        return diff.isLessOrEqual(tolerance)
    }
    
}
