//
//  KindKit
//

import KindCore

public protocol OneTrait {
	
	static var one: Self { get }
    
    var isOne: Bool { get }
    
}

public extension OneTrait {
    
    @inlinable
    var isNotOne: Bool {
        return !self.isOne
    }
    
}

public extension OneTrait where Self : Equatable {
    
    @inlinable
	var isOne: Bool {
        return self.isEqual(.one)
	}
    
}

public extension OneTrait where Self : BinaryInteger {
    
    @inlinable
    static var one: Self {
        return 1
    }
    
}

public extension OneTrait where Self : BinaryFloatingPoint {
    
    @inlinable
    static var one: Self {
        return 1
    }
    
}

public extension OneTrait where Self : EpsilonTrait & NearEqualTrait {
    
    @inlinable
    var isNearOne: Bool {
        return self.isNearEqual(.one)
    }
    
    @inlinable
    var isNearNotOne: Bool {
        return !self.isNearOne
    }
    
}
