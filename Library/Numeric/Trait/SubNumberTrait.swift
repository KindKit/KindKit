//
//  KindKit
//

public protocol SubNumberTrait {
    
    func subtracting< Other : BinaryInteger >(this other: Other) -> Self
    
    func subtracting< Other : BinaryFloatingPoint >(this other: Other) -> Self
    
}

public extension SubNumberTrait {
    
    @inlinable
    static func - < Right : BinaryInteger >(lhs: Self, rhs: Right) -> Self {
        return lhs.subtracting(this: rhs)
    }
    
    @inlinable
    static func -= < Right : BinaryInteger >(lhs: inout Self, rhs: Right) {
        lhs = lhs.subtracting(this: rhs)
    }
    
    @inlinable
    static func -= < Right : BinaryFloatingPoint >(lhs: Self, rhs: Right) -> Self {
        return lhs.subtracting(this: rhs)
    }
    
    @inlinable
    static func -= < Right : BinaryFloatingPoint >(lhs: inout Self, rhs: Right) {
        lhs = lhs.subtracting(this: rhs)
    }
    
}

public extension SubNumberTrait where Self : FromNumberTrait & SubTrait {
    
    @inlinable
    func subtracting< Other : BinaryInteger >(this other: Other) -> Self {
        return self.subtracting(this: Self.init(other))
    }
    
    @inlinable
    func subtracting< Other : BinaryFloatingPoint >(this other: Other) -> Self {
        return self.subtracting(this: Self.init(other))
    }
    
}
