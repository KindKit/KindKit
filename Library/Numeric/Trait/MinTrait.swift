//
//  KindKit
//

import KindCore

public protocol MinTrait {
	
	static var min: Self { get }
    
}

public extension MinTrait where Self : Equatable {
	
    @inlinable
    var isMin: Bool {
		return self == .min
	}
    
}

public extension MinTrait where Self : NearEqualTrait {
    
    @inlinable
    func isMin(tolerance: Self) -> Bool {
        return self.isEqual(.min, tolerance: tolerance)
    }
    
    @inlinable
    func isNotMin(tolerance: Self) -> Bool {
        return self.isMin(tolerance: tolerance) == false
    }
    
}

public extension MinTrait where Self : EpsilonTrait & NearEqualTrait {
    
    @inlinable
    var isNearMin: Bool {
        return self.isMin(tolerance: .epsilon)
    }
    
    @inlinable
    var isNotNearZero: Bool {
        return self.isNotMin(tolerance: .epsilon)
    }
    
}
