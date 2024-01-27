//
//  KindKit
//

import KindCore

public protocol ZeroTrait {
	
	static var zero: Self { get }
    
    var isZero: Bool { get }
    
}

public extension ZeroTrait {
    
    @inlinable
    var isNotZero: Bool {
        return !self.isZero
    }
    
}

public extension ZeroTrait where Self : Equatable {
    
    @inlinable
	var isZero: Bool {
        return self.isEqual(.zero)
	}
    
}

public extension ZeroTrait where Self : Comparable & NegativeTrait {
    
    @inlinable
    var isLessZero: Bool {
        return self.isLess(.zero)
    }
    
    @inlinable
    var isMoreZero: Bool {
        return self.isMore(.zero)
    }
    
}

public extension ZeroTrait where Self : NearEqualTrait {
    
    @inlinable
    func isZero(tolerance: Self) -> Bool {
        return self.isEqual(.zero, tolerance: tolerance)
    }
    
    @inlinable
    func isNotZero(tolerance: Self) -> Bool {
        return self.isZero(tolerance: tolerance) == false
    }
    
}

public extension ZeroTrait where Self : EpsilonTrait & NearEqualTrait {
    
    @inlinable
    var isNearZero: Bool {
        return self.isZero(tolerance: .epsilon)
    }
    
    @inlinable
    var isNotNearZero: Bool {
        return self.isNotZero(tolerance: .epsilon)
    }
    
}
