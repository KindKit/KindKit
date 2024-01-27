//
//  KindKit
//

import Foundation
import KindCore

// MARK: UInt

extension UInt : FromNumberTrait {}

extension UInt : ToNumberTrait {}

extension UInt : FromNSNumberTrait {}

extension UInt : ToNSNumberTrait {
    
    @inlinable
    public var nsNumber: NSNumber {
        return .init(value: self)
    }
    
}

extension UInt : ZeroTrait {}

extension UInt : MinTrait {}

extension UInt : MaxTrait {}

extension UInt : AddTrait {}

extension UInt : AddNumberTrait {}

extension UInt : AddPercentTrait {}

extension UInt : SubTrait {}

extension UInt : SubNumberTrait {}

extension UInt : SubPercentTrait {}

extension UInt : MulTrait {}

extension UInt : MulNumberTrait {}

extension UInt : MulPercentTrait {}

extension UInt : DivTrait {}

extension UInt : DivNumberTrait {}

extension UInt : NearCompareTrait {}

extension UInt : NearEqualTrait {}

extension UInt : WrapTrait {}

// MARK: UInt8

extension UInt8 : FromNumberTrait {}

extension UInt8 : ToNumberTrait {}

extension UInt8 : FromNSNumberTrait {}

extension UInt8 : ToNSNumberTrait {
    
    @inlinable
    public var nsNumber: NSNumber {
        return .init(value: self)
    }
    
}

extension UInt8 : ZeroTrait {}

extension UInt8 : MinTrait {}

extension UInt8 : MaxTrait {}

extension UInt8 : AddTrait {}

extension UInt8 : AddNumberTrait {}

extension UInt8 : AddPercentTrait {}

extension UInt8 : SubTrait {}

extension UInt8 : SubNumberTrait {}

extension UInt8 : SubPercentTrait {}

extension UInt8 : MulTrait {}

extension UInt8 : MulNumberTrait {}

extension UInt8 : MulPercentTrait {}

extension UInt8 : DivTrait {}

extension UInt8 : DivNumberTrait {}

extension UInt8 : NearCompareTrait {}

extension UInt8 : NearEqualTrait {}

extension UInt8 : WrapTrait {}

// MARK: UInt16

extension UInt16 : FromNumberTrait {}

extension UInt16 : ToNumberTrait {}

extension UInt16 : FromNSNumberTrait {}

extension UInt16 : ToNSNumberTrait {
    
    @inlinable
    public var nsNumber: NSNumber {
        return .init(value: self)
    }
    
}

extension UInt16 : ZeroTrait {}

extension UInt16 : MinTrait {}

extension UInt16 : MaxTrait {}

extension UInt16 : AddTrait {}

extension UInt16 : AddNumberTrait {}

extension UInt16 : AddPercentTrait {}

extension UInt16 : SubTrait {}

extension UInt16 : SubNumberTrait {}

extension UInt16 : SubPercentTrait {}

extension UInt16 : MulTrait {}

extension UInt16 : MulNumberTrait {}

extension UInt16 : MulPercentTrait {}

extension UInt16 : DivTrait {}

extension UInt16 : DivNumberTrait {}

extension UInt16 : NearCompareTrait {}

extension UInt16 : NearEqualTrait {}

extension UInt16 : WrapTrait {}

// MARK: UInt32

extension UInt32 : FromNumberTrait {}

extension UInt32 : ToNumberTrait {}

extension UInt32 : FromNSNumberTrait {}

extension UInt32 : ToNSNumberTrait {
    
    @inlinable
    public var nsNumber: NSNumber {
        return .init(value: self)
    }
    
}

extension UInt32 : ZeroTrait {}

extension UInt32 : MinTrait {}

extension UInt32 : MaxTrait {}

extension UInt32 : AddTrait {}

extension UInt32 : AddNumberTrait {}

extension UInt32 : AddPercentTrait {}

extension UInt32 : SubTrait {}

extension UInt32 : SubNumberTrait {}

extension UInt32 : SubPercentTrait {}

extension UInt32 : MulTrait {}

extension UInt32 : MulNumberTrait {}

extension UInt32 : MulPercentTrait {}

extension UInt32 : DivTrait {}

extension UInt32 : DivNumberTrait {}

extension UInt32 : NearCompareTrait {}

extension UInt32 : NearEqualTrait {}

extension UInt32 : WrapTrait {}

// MARK: UInt64

extension UInt64 : FromNumberTrait {}

extension UInt64 : ToNumberTrait {}

extension UInt64 : FromNSNumberTrait {}

extension UInt64 : ToNSNumberTrait {
    
    @inlinable
    public var nsNumber: NSNumber {
        return .init(value: self)
    }
    
}

extension UInt64 : ZeroTrait {}

extension UInt64 : MinTrait {}

extension UInt64 : MaxTrait {}

extension UInt64 : AddTrait {}

extension UInt64 : AddNumberTrait {}

extension UInt64 : AddPercentTrait {}

extension UInt64 : SubTrait {}

extension UInt64 : SubNumberTrait {}

extension UInt64 : SubPercentTrait {}

extension UInt64 : MulTrait {}

extension UInt64 : MulNumberTrait {}

extension UInt64 : MulPercentTrait {}

extension UInt64 : DivTrait {}

extension UInt64 : DivNumberTrait {}

extension UInt64 : NearCompareTrait {}

extension UInt64 : NearEqualTrait {}

extension UInt64 : WrapTrait {}
