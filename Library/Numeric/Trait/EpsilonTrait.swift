//
//  KindKit
//

import KindCore

public protocol EpsilonTrait {
	
	static var epsilon: Self { get }
    
}

public extension EpsilonTrait where Self : BinaryFloatingPoint {
    
    @inlinable
    static var epsilon: Self {
        return self.ulpOfOne
    }
    
}

public extension EpsilonTrait where Self : Comparable {
    
    @inlinable
    var isLessEpsilon: Bool {
        return self.isLess(.epsilon)
    }
    
    @inlinable
    var isMoreEpsilon: Bool {
        return self.isMore(.epsilon)
    }
    
}
