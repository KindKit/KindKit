//
//  KindKit
//

public protocol AddNumberTrait {
	
    func adding< Added : BinaryInteger >(on addend: Added) -> Self
    
    func adding< Added : BinaryFloatingPoint >(on addend: Added) -> Self
    
}

public extension AddNumberTrait {
    
    @inlinable
    static func + < Right : BinaryInteger >(lhs: Self, rhs: Right) -> Self {
        return lhs.adding(on: rhs)
    }
    
    @inlinable
    static func += < Right : BinaryInteger >(lhs: inout Self, rhs: Right) {
        lhs = lhs.adding(on: rhs)
    }
    
    @inlinable
    static func += < Right : BinaryFloatingPoint >(lhs: Self, rhs: Right) -> Self {
        return lhs.adding(on: rhs)
    }
    
    @inlinable
    static func += < Right : BinaryFloatingPoint >(lhs: inout Self, rhs: Right) {
        lhs = lhs.adding(on: rhs)
    }
    
}

public extension AddNumberTrait where Self : FromNumberTrait & AddTrait {
    
    @inlinable
    func adding< Added : BinaryInteger >(on addend: Added) -> Self {
        return self.adding(on: Self.init(addend))
    }
    
    @inlinable
    func adding< Added : BinaryFloatingPoint >(on addend: Added) -> Self {
        return self.adding(on: Self.init(addend))
    }
    
}
