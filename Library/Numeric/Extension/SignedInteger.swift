//
//  KindKit
//

import Foundation
import KindCore

// MARK: Int

extension Int : FromNumberTrait {}

extension Int : ToNumberTrait {}

extension Int : FromNSNumberTrait {}

extension Int : ToNSNumberTrait {
    
    @inlinable
    public var nsNumber: NSNumber {
        return .init(value: self)
    }
    
}

extension Int : ZeroTrait {}

extension Int : MinTrait {}

extension Int : MaxTrait {}

extension Int : AddTrait {}

extension Int : AddNumberTrait {}

extension Int : AddPercentTrait {}

extension Int : SubTrait {}

extension Int : SubNumberTrait {
    
    @inlinable
    public static func - < Input : BinaryInteger >(lhs: Self, rhs: Input) -> Self {
        return lhs - Self(rhs)
    }
    
    @inlinable
    public static func - < Input : BinaryFloatingPoint >(lhs: Self, rhs: Input) -> Self {
        return lhs - Self(rhs)
    }
    
    @inlinable
    public static func - < Input : BinaryInteger >(lhs: Input, rhs: Self) -> Self {
        return Self(lhs) - rhs
    }
    
    @inlinable
    public static func - < Input : BinaryFloatingPoint >(lhs: Input, rhs: Self) -> Self {
        return Self(lhs) - rhs
    }
    
}

extension Int : SubPercentTrait {}

extension Int : MulTrait {}

extension Int : MulNumberTrait {
    
    @inlinable
    public static func * < Input : BinaryInteger >(lhs: Self, rhs: Input) -> Self {
        return lhs * Self(rhs)
    }
    
    @inlinable
    public static func * < Input : BinaryFloatingPoint >(lhs: Self, rhs: Input) -> Self {
        return lhs * Self(rhs)
    }
    
    @inlinable
    public static func * < Input : BinaryInteger >(lhs: Input, rhs: Self) -> Self {
        return Self(lhs) * rhs
    }
    
    @inlinable
    public static func * < Input : BinaryFloatingPoint >(lhs: Input, rhs: Self) -> Self {
        return Self(lhs) * rhs
    }
    
}

extension Int : MulPercentTrait {}

extension Int : DivTrait {}

extension Int : DivNumberTrait {
    
    @inlinable
    public static func / < Input : BinaryInteger >(lhs: Self, rhs: Input) -> Self {
        return lhs / Self(rhs)
    }
    
    @inlinable
    public static func / < Input : BinaryFloatingPoint >(lhs: Self, rhs: Input) -> Self {
        return lhs / Self(rhs)
    }
    
    @inlinable
    public static func / < Input : BinaryInteger >(lhs: Input, rhs: Self) -> Self {
        return Self(lhs) / rhs
    }
    
    @inlinable
    public static func / < Input : BinaryFloatingPoint >(lhs: Input, rhs: Self) -> Self {
        return Self(lhs) / rhs
    }
    
    @inlinable
    public static func % < Input : BinaryInteger >(lhs: Self, rhs: Input) -> Self {
        return lhs % Self(rhs)
    }
    
    @inlinable
    public static func % < Input : BinaryFloatingPoint >(lhs: Self, rhs: Input) -> Self {
        return lhs % Self(rhs)
    }
    
    @inlinable
    public static func % < Input : BinaryInteger >(lhs: Input, rhs: Self) -> Self {
        return Self(lhs) % rhs
    }
    
    @inlinable
    public static func % < Input : BinaryFloatingPoint >(lhs: Input, rhs: Self) -> Self {
        return Self(lhs) % rhs
    }
    
}

extension Int : NegativeTrait {}

extension Int : NearCompareTrait {}

extension Int : NearEqualTrait {}

extension Int : WrapTrait {}

// MARK: Int8

extension Int8 : FromNumberTrait {}

extension Int8 : ToNumberTrait {}

extension Int8 : FromNSNumberTrait {}

extension Int8 : ToNSNumberTrait {
    
    @inlinable
    public var nsNumber: NSNumber {
        return .init(value: self)
    }
    
}

extension Int8 : ZeroTrait {}

extension Int8 : MinTrait {}

extension Int8 : MaxTrait {}

extension Int8 : AddTrait {}

extension Int8 : AddNumberTrait {}

extension Int8 : AddPercentTrait {}

extension Int8 : SubTrait {}

extension Int8 : SubNumberTrait {
    
    @inlinable
    public static func - < Input : BinaryInteger >(lhs: Self, rhs: Input) -> Self {
        return lhs - Self(rhs)
    }
    
    @inlinable
    public static func - < Input : BinaryFloatingPoint >(lhs: Self, rhs: Input) -> Self {
        return lhs - Self(rhs)
    }
    
    @inlinable
    public static func - < Input : BinaryInteger >(lhs: Input, rhs: Self) -> Self {
        return Self(lhs) - rhs
    }
    
    @inlinable
    public static func - < Input : BinaryFloatingPoint >(lhs: Input, rhs: Self) -> Self {
        return Self(lhs) - rhs
    }
    
}

extension Int8 : SubPercentTrait {}

extension Int8 : MulTrait {}

extension Int8 : MulNumberTrait {
    
    @inlinable
    public static func * < Input : BinaryInteger >(lhs: Self, rhs: Input) -> Self {
        return lhs * Self(rhs)
    }
    
    @inlinable
    public static func * < Input : BinaryFloatingPoint >(lhs: Self, rhs: Input) -> Self {
        return lhs * Self(rhs)
    }
    
    @inlinable
    public static func * < Input : BinaryInteger >(lhs: Input, rhs: Self) -> Self {
        return Self(lhs) * rhs
    }
    
    @inlinable
    public static func * < Input : BinaryFloatingPoint >(lhs: Input, rhs: Self) -> Self {
        return Self(lhs) * rhs
    }
    
}

extension Int8 : MulPercentTrait {}

extension Int8 : DivTrait {}

extension Int8 : DivNumberTrait {
    
    @inlinable
    public static func / < Input : BinaryInteger >(lhs: Self, rhs: Input) -> Self {
        return lhs / Self(rhs)
    }
    
    @inlinable
    public static func / < Input : BinaryFloatingPoint >(lhs: Self, rhs: Input) -> Self {
        return lhs / Self(rhs)
    }
    
    @inlinable
    public static func / < Input : BinaryInteger >(lhs: Input, rhs: Self) -> Self {
        return Self(lhs) / rhs
    }
    
    @inlinable
    public static func / < Input : BinaryFloatingPoint >(lhs: Input, rhs: Self) -> Self {
        return Self(lhs) / rhs
    }
    
    @inlinable
    public static func % < Input : BinaryInteger >(lhs: Self, rhs: Input) -> Self {
        return lhs % Self(rhs)
    }
    
    @inlinable
    public static func % < Input : BinaryFloatingPoint >(lhs: Self, rhs: Input) -> Self {
        return lhs % Self(rhs)
    }
    
    @inlinable
    public static func % < Input : BinaryInteger >(lhs: Input, rhs: Self) -> Self {
        return Self(lhs) % rhs
    }
    
    @inlinable
    public static func % < Input : BinaryFloatingPoint >(lhs: Input, rhs: Self) -> Self {
        return Self(lhs) % rhs
    }
    
}

extension Int8 : NegativeTrait {}

extension Int8 : NearCompareTrait {}

extension Int8 : NearEqualTrait {}

extension Int8 : WrapTrait {}

// MARK: Int16

extension Int16 : FromNumberTrait {}

extension Int16 : ToNumberTrait {}

extension Int16 : FromNSNumberTrait {}

extension Int16 : ToNSNumberTrait {
    
    @inlinable
    public var nsNumber: NSNumber {
        return .init(value: self)
    }
    
}

extension Int16 : ZeroTrait {}

extension Int16 : MinTrait {}

extension Int16 : MaxTrait {}

extension Int16 : AddTrait {}

extension Int16 : AddNumberTrait {}

extension Int16 : AddPercentTrait {}

extension Int16 : SubTrait {}

extension Int16 : SubNumberTrait {
    
    @inlinable
    public static func - < Input : BinaryInteger >(lhs: Self, rhs: Input) -> Self {
        return lhs - Self(rhs)
    }
    
    @inlinable
    public static func - < Input : BinaryFloatingPoint >(lhs: Self, rhs: Input) -> Self {
        return lhs - Self(rhs)
    }
    
    @inlinable
    public static func - < Input : BinaryInteger >(lhs: Input, rhs: Self) -> Self {
        return Self(lhs) - rhs
    }
    
    @inlinable
    public static func - < Input : BinaryFloatingPoint >(lhs: Input, rhs: Self) -> Self {
        return Self(lhs) - rhs
    }
    
}

extension Int16 : SubPercentTrait {}

extension Int16 : MulTrait {}

extension Int16 : MulNumberTrait {
    
    @inlinable
    public static func * < Input : BinaryInteger >(lhs: Self, rhs: Input) -> Self {
        return lhs * Self(rhs)
    }
    
    @inlinable
    public static func * < Input : BinaryFloatingPoint >(lhs: Self, rhs: Input) -> Self {
        return lhs * Self(rhs)
    }
    
    @inlinable
    public static func * < Input : BinaryInteger >(lhs: Input, rhs: Self) -> Self {
        return Self(lhs) * rhs
    }
    
    @inlinable
    public static func * < Input : BinaryFloatingPoint >(lhs: Input, rhs: Self) -> Self {
        return Self(lhs) * rhs
    }
    
}

extension Int16 : MulPercentTrait {}

extension Int16 : DivTrait {}

extension Int16 : DivNumberTrait {
    
    @inlinable
    public static func / < Input : BinaryInteger >(lhs: Self, rhs: Input) -> Self {
        return lhs / Self(rhs)
    }
    
    @inlinable
    public static func / < Input : BinaryFloatingPoint >(lhs: Self, rhs: Input) -> Self {
        return lhs / Self(rhs)
    }
    
    @inlinable
    public static func / < Input : BinaryInteger >(lhs: Input, rhs: Self) -> Self {
        return Self(lhs) / rhs
    }
    
    @inlinable
    public static func / < Input : BinaryFloatingPoint >(lhs: Input, rhs: Self) -> Self {
        return Self(lhs) / rhs
    }
    
    @inlinable
    public static func % < Input : BinaryInteger >(lhs: Self, rhs: Input) -> Self {
        return lhs % Self(rhs)
    }
    
    @inlinable
    public static func % < Input : BinaryFloatingPoint >(lhs: Self, rhs: Input) -> Self {
        return lhs % Self(rhs)
    }
    
    @inlinable
    public static func % < Input : BinaryInteger >(lhs: Input, rhs: Self) -> Self {
        return Self(lhs) % rhs
    }
    
    @inlinable
    public static func % < Input : BinaryFloatingPoint >(lhs: Input, rhs: Self) -> Self {
        return Self(lhs) % rhs
    }
    
}

extension Int16 : NegativeTrait {}

extension Int16 : NearCompareTrait {}

extension Int16 : NearEqualTrait {}

extension Int16 : WrapTrait {}

// MARK: Int32

extension Int32 : FromNumberTrait {}

extension Int32 : ToNumberTrait {}

extension Int32 : FromNSNumberTrait {}

extension Int32 : ToNSNumberTrait {
    
    @inlinable
    public var nsNumber: NSNumber {
        return .init(value: self)
    }
    
}

extension Int32 : ZeroTrait {}

extension Int32 : MinTrait {}

extension Int32 : MaxTrait {}

extension Int32 : AddTrait {}

extension Int32 : AddNumberTrait {}

extension Int32 : AddPercentTrait {}

extension Int32 : SubTrait {}

extension Int32 : SubNumberTrait {
    
    @inlinable
    public static func - < Input : BinaryInteger >(lhs: Self, rhs: Input) -> Self {
        return lhs - Self(rhs)
    }
    
    @inlinable
    public static func - < Input : BinaryFloatingPoint >(lhs: Self, rhs: Input) -> Self {
        return lhs - Self(rhs)
    }
    
    @inlinable
    public static func - < Input : BinaryInteger >(lhs: Input, rhs: Self) -> Self {
        return Self(lhs) - rhs
    }
    
    @inlinable
    public static func - < Input : BinaryFloatingPoint >(lhs: Input, rhs: Self) -> Self {
        return Self(lhs) - rhs
    }
    
}

extension Int32 : SubPercentTrait {}

extension Int32 : MulTrait {}

extension Int32 : MulNumberTrait {
    
    @inlinable
    public static func * < Input : BinaryInteger >(lhs: Self, rhs: Input) -> Self {
        return lhs * Self(rhs)
    }
    
    @inlinable
    public static func * < Input : BinaryFloatingPoint >(lhs: Self, rhs: Input) -> Self {
        return lhs * Self(rhs)
    }
    
    @inlinable
    public static func * < Input : BinaryInteger >(lhs: Input, rhs: Self) -> Self {
        return Self(lhs) * rhs
    }
    
    @inlinable
    public static func * < Input : BinaryFloatingPoint >(lhs: Input, rhs: Self) -> Self {
        return Self(lhs) * rhs
    }
    
}

extension Int32 : MulPercentTrait {}

extension Int32 : DivTrait {}

extension Int32 : DivNumberTrait {
    
    @inlinable
    public static func / < Input : BinaryInteger >(lhs: Self, rhs: Input) -> Self {
        return lhs / Self(rhs)
    }
    
    @inlinable
    public static func / < Input : BinaryFloatingPoint >(lhs: Self, rhs: Input) -> Self {
        return lhs / Self(rhs)
    }
    
    @inlinable
    public static func / < Input : BinaryInteger >(lhs: Input, rhs: Self) -> Self {
        return Self(lhs) / rhs
    }
    
    @inlinable
    public static func / < Input : BinaryFloatingPoint >(lhs: Input, rhs: Self) -> Self {
        return Self(lhs) / rhs
    }
    
    @inlinable
    public static func % < Input : BinaryInteger >(lhs: Self, rhs: Input) -> Self {
        return lhs % Self(rhs)
    }
    
    @inlinable
    public static func % < Input : BinaryFloatingPoint >(lhs: Self, rhs: Input) -> Self {
        return lhs % Self(rhs)
    }
    
    @inlinable
    public static func % < Input : BinaryInteger >(lhs: Input, rhs: Self) -> Self {
        return Self(lhs) % rhs
    }
    
    @inlinable
    public static func % < Input : BinaryFloatingPoint >(lhs: Input, rhs: Self) -> Self {
        return Self(lhs) % rhs
    }
    
}

extension Int32 : NegativeTrait {}

extension Int32 : NearCompareTrait {}

extension Int32 : NearEqualTrait {}

extension Int32 : WrapTrait {}

// MARK: Int64

extension Int64 : FromNumberTrait {}

extension Int64 : ToNumberTrait {}

extension Int64 : FromNSNumberTrait {}

extension Int64 : ToNSNumberTrait {
    
    @inlinable
    public var nsNumber: NSNumber {
        return .init(value: self)
    }
    
}

extension Int64 : ZeroTrait {}

extension Int64 : MinTrait {}

extension Int64 : MaxTrait {}

extension Int64 : AddTrait {}

extension Int64 : AddNumberTrait {}

extension Int64 : AddPercentTrait {}

extension Int64 : SubTrait {}

extension Int64 : SubPercentTrait {}

extension Int64 : SubNumberTrait {
    
    @inlinable
    public static func - < Input : BinaryInteger >(lhs: Self, rhs: Input) -> Self {
        return lhs - Self(rhs)
    }
    
    @inlinable
    public static func - < Input : BinaryFloatingPoint >(lhs: Self, rhs: Input) -> Self {
        return lhs - Self(rhs)
    }
    
    @inlinable
    public static func - < Input : BinaryInteger >(lhs: Input, rhs: Self) -> Self {
        return Self(lhs) - rhs
    }
    
    @inlinable
    public static func - < Input : BinaryFloatingPoint >(lhs: Input, rhs: Self) -> Self {
        return Self(lhs) - rhs
    }
    
}

extension Int64 : MulTrait {}

extension Int64 : MulPercentTrait {}

extension Int64 : MulNumberTrait {
    
    @inlinable
    public static func * < Input : BinaryInteger >(lhs: Self, rhs: Input) -> Self {
        return lhs * Self(rhs)
    }
    
    @inlinable
    public static func * < Input : BinaryFloatingPoint >(lhs: Self, rhs: Input) -> Self {
        return lhs * Self(rhs)
    }
    
    @inlinable
    public static func * < Input : BinaryInteger >(lhs: Input, rhs: Self) -> Self {
        return Self(lhs) * rhs
    }
    
    @inlinable
    public static func * < Input : BinaryFloatingPoint >(lhs: Input, rhs: Self) -> Self {
        return Self(lhs) * rhs
    }
    
}

extension Int64 : DivTrait {}

extension Int64 : DivNumberTrait {
    
    @inlinable
    public static func / < Input : BinaryInteger >(lhs: Self, rhs: Input) -> Self {
        return lhs / Self(rhs)
    }
    
    @inlinable
    public static func / < Input : BinaryFloatingPoint >(lhs: Self, rhs: Input) -> Self {
        return lhs / Self(rhs)
    }
    
    @inlinable
    public static func / < Input : BinaryInteger >(lhs: Input, rhs: Self) -> Self {
        return Self(lhs) / rhs
    }
    
    @inlinable
    public static func / < Input : BinaryFloatingPoint >(lhs: Input, rhs: Self) -> Self {
        return Self(lhs) / rhs
    }
    
    @inlinable
    public static func % < Input : BinaryInteger >(lhs: Self, rhs: Input) -> Self {
        return lhs % Self(rhs)
    }
    
    @inlinable
    public static func % < Input : BinaryFloatingPoint >(lhs: Self, rhs: Input) -> Self {
        return lhs % Self(rhs)
    }
    
    @inlinable
    public static func % < Input : BinaryInteger >(lhs: Input, rhs: Self) -> Self {
        return Self(lhs) % rhs
    }
    
    @inlinable
    public static func % < Input : BinaryFloatingPoint >(lhs: Input, rhs: Self) -> Self {
        return Self(lhs) % rhs
    }
    
}

extension Int64 : NegativeTrait {}

extension Int64 : NearCompareTrait {}

extension Int64 : NearEqualTrait {}

extension Int64 : WrapTrait {}
