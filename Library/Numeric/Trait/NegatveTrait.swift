//
//  KindKit
//

import KindCore

public protocol NegativeTrait {
    
    func negating() -> Self
    
}

public extension NegativeTrait {
    
    @inlinable
    prefix static func - (other: Self) -> Self {
        return other.negating()
	}
    
}

public extension NegativeTrait where Self : Equatable {
    
    @inlinable
    func isOpposite(of other: Self) -> Bool {
        return self == other.negating()
    }
    
}

public extension NegativeTrait where Self : Comparable & ZeroTrait {
    
    @inlinable
    var abs: Self {
        return self.isNegative == true ? -self : self
    }
    
    @inlinable
    var isNegative: Bool {
        return self.isLessZero
    }
    
    @inlinable
    var isPositive: Bool {
        return self.isMoreZero
    }
    
}

public extension NegativeTrait where Self : SignedNumeric {
    
    @inlinable
    func negating() -> Self {
		return 0 - self
	}
    
}
