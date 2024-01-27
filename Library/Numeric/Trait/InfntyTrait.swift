//
//  KindKit
//

public protocol InfinityTrait {
	
	static var infinity: Self { get }
    
    var isFinite: Bool { get }
    var isInfinite: Bool { get }
    
}

public extension InfinityTrait where Self : NegativeTrait {
    
    @inlinable
    static var negativeInfinity: Self {
		return .infinity.negating()
	}
    
}
