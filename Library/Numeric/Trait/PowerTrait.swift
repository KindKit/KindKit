//
//  KindKit
//

public protocol PowerTrait {
	
    var sqrt: Self { get }
    
    func pow(_ other: Self) -> Self
    
    static func base(digits: UInt) -> Self
    
}

public extension PowerTrait where Self : BinaryInteger {
    
    @inlinable
    static func base(digits: UInt) -> Self {
        return Self(10).pow(Self(digits))
    }
    
}

public extension PowerTrait where Self : BinaryFloatingPoint {
    
    @inlinable
    static func base(digits: UInt) -> Self {
        return Self(10).pow(Self(digits))
    }
    
}
