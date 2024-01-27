//
//  KindKit
//

import KindCore

public protocol MaxTrait {
	
	static var max: Self { get }
    
}

public extension MaxTrait where Self : Equatable {
	
    @inlinable
	var isMax: Bool {
        return self.isEqual(.max)
	}
    
}

public extension MaxTrait where Self : NearEqualTrait {
    
    @inlinable
    func isMax(tolerance: Self) -> Bool {
        return self.isEqual(.max, tolerance: tolerance)
    }
    
    @inlinable
    func isNotMax(tolerance: Self) -> Bool {
        return !self.isMax(tolerance: tolerance)
    }
    
}

public extension MaxTrait where Self : EpsilonTrait & NearEqualTrait {
    
    @inlinable
    var isNearMax: Bool {
        return self.isMax(tolerance: .epsilon)
    }
    
    @inlinable
    var isNotNearZero: Bool {
        return self.isNotMax(tolerance: .epsilon)
    }
    
}
