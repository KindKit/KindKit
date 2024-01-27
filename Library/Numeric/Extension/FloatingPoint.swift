//
//  KindKit
//

import Foundation
import KindCore

// MARK: Float16

@available(iOS 14, macCatalyst 14.5, macOS 11, tvOS 14, watchOS 7, *)
extension Float16 : FromNumberTrait {}

@available(iOS 14, macCatalyst 14.5, macOS 11, tvOS 14, watchOS 7, *)
extension Float16 : ToNumberTrait {}

@available(iOS 14, macCatalyst 14.5, macOS 11, tvOS 14, watchOS 7, *)
extension Float16 : FromNSNumberTrait {
    
    @inlinable
    public init(truncating number: NSNumber) {
        self.init(number.floatValue)
    }
    
    @inlinable
    public init?(exactly number: NSNumber) {
        self.init(number.floatValue)
    }
    
}

@available(iOS 14, macCatalyst 14.5, macOS 11, tvOS 14, watchOS 7, *)
extension Float16 : ToNSNumberTrait {
    
    @inlinable
    public var nsNumber: NSNumber {
        return .init(value: Float(self))
    }
    
}

@available(iOS 14, macCatalyst 14.5, macOS 11, tvOS 14, watchOS 7, *)
extension Float16 : EpsilonTrait {}

@available(iOS 14, macCatalyst 14.5, macOS 11, tvOS 14, watchOS 7, *)
extension Float16 : InfinityTrait {}

@available(iOS 14, macCatalyst 14.5, macOS 11, tvOS 14, watchOS 7, *)
extension Float16 : NaNTrait {}

@available(iOS 14, macCatalyst 14.5, macOS 11, tvOS 14, watchOS 7, *)
extension Float16 : ZeroTrait {}

@available(iOS 14, macCatalyst 14.5, macOS 11, tvOS 14, watchOS 7, *)
extension Float16 : OneTrait {}

@available(iOS 14, macCatalyst 14.5, macOS 11, tvOS 14, watchOS 7, *)
extension Float16 : MinTrait {
    
    @inlinable
    public static var min: Self {
        return -Self.greatestFiniteMagnitude
    }
    
}

@available(iOS 14, macCatalyst 14.5, macOS 11, tvOS 14, watchOS 7, *)
extension Float16 : MaxTrait {
    
    @inlinable
    public static var max: Self {
        return Self.greatestFiniteMagnitude
    }
    
}

@available(iOS 14, macCatalyst 14.5, macOS 11, tvOS 14, watchOS 7, *)
extension Float16 : AddTrait {}

@available(iOS 14, macCatalyst 14.5, macOS 11, tvOS 14, watchOS 7, *)
extension Float16 : AddNumberTrait {}

@available(iOS 14, macCatalyst 14.5, macOS 11, tvOS 14, watchOS 7, *)
extension Float16 : AddPercentTrait {}

@available(iOS 14, macCatalyst 14.5, macOS 11, tvOS 14, watchOS 7, *)
extension Float16 : SubTrait {}

@available(iOS 14, macCatalyst 14.5, macOS 11, tvOS 14, watchOS 7, *)
extension Float16 : SubNumberTrait {}

@available(iOS 14, macCatalyst 14.5, macOS 11, tvOS 14, watchOS 7, *)
extension Float16 : SubPercentTrait {}

@available(iOS 14, macCatalyst 14.5, macOS 11, tvOS 14, watchOS 7, *)
extension Float16 : MulTrait {}

@available(iOS 14, macCatalyst 14.5, macOS 11, tvOS 14, watchOS 7, *)
extension Float16 : MulNumberTrait {}

@available(iOS 14, macCatalyst 14.5, macOS 11, tvOS 14, watchOS 7, *)
extension Float16 : MulPercentTrait {}

@available(iOS 14, macCatalyst 14.5, macOS 11, tvOS 14, watchOS 7, *)
extension Float16 : DivTrait {}

@available(iOS 14, macCatalyst 14.5, macOS 11, tvOS 14, watchOS 7, *)
extension Float16 : DivNumberTrait {}

@available(iOS 14, macCatalyst 14.5, macOS 11, tvOS 14, watchOS 7, *)
extension Float16 : NegativeTrait {}

@available(iOS 14, macCatalyst 14.5, macOS 11, tvOS 14, watchOS 7, *)
extension Float16 : NearCompareTrait {}

@available(iOS 14, macCatalyst 14.5, macOS 11, tvOS 14, watchOS 7, *)
extension Float16 : NearEqualTrait {}

@available(iOS 14, macCatalyst 14.5, macOS 11, tvOS 14, watchOS 7, *)
extension Float16 : NormalizeTrait {
    
    public typealias Normalized = Self
    
}

@available(iOS 14, macCatalyst 14.5, macOS 11, tvOS 14, watchOS 7, *)
extension Float16 : ValidationTrait {
    
    @inlinable
    public var validated: Self {
        return .zero
    }
    
}

@available(iOS 14, macCatalyst 14.5, macOS 11, tvOS 14, watchOS 7, *)
extension Float16 : WrapTrait {}

@available(iOS 14, macCatalyst 14.5, macOS 11, tvOS 14, watchOS 7, *)
extension Float16 : LerpTrait {}

// MARK: Float32

extension Float32 : FromNumberTrait {}

extension Float32 : ToNumberTrait {}

extension Float32 : FromNSNumberTrait {}

extension Float32 : ToNSNumberTrait {
    
    @inlinable
    public var nsNumber: NSNumber {
        return .init(value: self)
    }
    
}

extension Float32 : EpsilonTrait {}

extension Float32 : InfinityTrait {}

extension Float32 : NaNTrait {}

extension Float32 : ZeroTrait {}

extension Float32 : OneTrait {}

extension Float32 : MinTrait {
    
    @inlinable
    public static var min: Self {
        return -Self.greatestFiniteMagnitude
    }
    
}

extension Float32 : MaxTrait {
    
    @inlinable
    public static var max: Self {
        return Self.greatestFiniteMagnitude
    }
    
}

extension Float32 : AddTrait {}

extension Float32 : AddNumberTrait {}

extension Float32 : AddPercentTrait {}

extension Float32 : SubTrait {}

extension Float32 : SubNumberTrait {}

extension Float32 : SubPercentTrait {}

extension Float32 : MulTrait {}

extension Float32 : MulNumberTrait {}

extension Float32 : MulPercentTrait {}

extension Float32 : DivTrait {}

extension Float32 : DivNumberTrait {}

extension Float32 : NegativeTrait {}

extension Float32 : NearCompareTrait {}

extension Float32 : NearEqualTrait {}

extension Float32 : NormalizeTrait {
    
    public typealias Normalized = Self
    
}

extension Float32 : RoundTrait {}

extension Float32 : ValidationTrait {
    
    @inlinable
    public var validated: Self {
        return .zero
    }
    
}

extension Float32 : WrapTrait {}

extension Float32 : LerpTrait {}

extension Float32 : PowerTrait {
    
    @inlinable
    public var sqrt: Float {
        return Foundation.sqrt(self)
    }
    
    @inlinable
    public func pow(_ other: Self) -> Self {
        return Foundation.pow(self, other)
    }
    
}

extension Float32 : ExponentTrait {
    
    @inlinable
    public var exp: Self {
        return Foundation.exp(self)
    }
    
    @inlinable
    public var exp2: Self {
        return Foundation.exp2(self)
    }
    
    @inlinable
    public var expm1: Self {
        return Foundation.expm1(self)
    }
    
    @inlinable
    public var log: Self {
        return Foundation.log(self)
    }
    
    @inlinable
    public var log1p: Self {
        return Foundation.log1p(self)
    }
    
    @inlinable
    public var log2: Self {
        return Foundation.log2(self)
    }
    
    @inlinable
    public var log10: Self {
        return Foundation.log10(self)
    }
    
}

extension Float32 : TrigonometricTrait {
    
    @inlinable
    public var sin: Self {
        return Foundation.sin(self)
    }
    
    @inlinable
    public var asin: Self {
        return Foundation.asin(self)
    }
    
    @inlinable
    public var cos: Self {
        return Foundation.cos(self)
    }
    
    @inlinable
    public var acos: Self {
        return Foundation.acos(self)
    }
    
    @inlinable
    public var tan: Self {
        return Foundation.tan(self)
    }
    
    @inlinable
    public var atan: Self {
        return Foundation.atan(self)
    }
    
    @inlinable
    public func atan2(_ other: Self) -> Self {
        return Foundation.atan2(self, other)
    }
    
}

// MARK: Float64

extension Float64 : FromNumberTrait {}

extension Float64 : ToNumberTrait {}

extension Float64 : FromNSNumberTrait {}

extension Float64 : ToNSNumberTrait {
    
    @inlinable
    public var nsNumber: NSNumber {
        return .init(value: self)
    }
    
}

extension Float64 : EpsilonTrait {}

extension Float64 : InfinityTrait {}

extension Float64 : NaNTrait {}

extension Float64 : ZeroTrait {}

extension Float64 : OneTrait {}

extension Float64 : MinTrait {
    
    @inlinable
    public static var min: Self {
        return -Self.greatestFiniteMagnitude
    }
    
}

extension Float64 : MaxTrait {
    
    @inlinable
    public static var max: Self {
        return Self.greatestFiniteMagnitude
    }
    
}

extension Float64 : AddTrait {}

extension Float64 : AddNumberTrait {}

extension Float64 : AddPercentTrait {}

extension Float64 : SubTrait {}

extension Float64 : SubNumberTrait {}

extension Float64 : SubPercentTrait {}

extension Float64 : MulTrait {}

extension Float64 : MulNumberTrait {}

extension Float64 : MulPercentTrait {}

extension Float64 : DivTrait {}

extension Float64 : DivNumberTrait {}

extension Float64 : NegativeTrait {}

extension Float64 : NearCompareTrait {}

extension Float64 : NearEqualTrait {}

extension Float64 : NormalizeTrait {
    
    public typealias Normalized = Self
    
}

extension Float64 : RoundTrait {}

extension Float64 : ValidationTrait {
    
    @inlinable
    public var validated: Self {
        return .zero
    }
    
}

extension Float64 : WrapTrait {}

extension Float64 : LerpTrait {}

extension Float64 : PowerTrait {
    
    @inlinable
    public var sqrt: Self {
        return Foundation.sqrt(self)
    }
    
    @inlinable
    public func pow(_ other: Self) -> Self {
        return Foundation.pow(self, other)
    }
    
}

extension Float64 : ExponentTrait {
    
    @inlinable
    public var exp: Self {
        return Foundation.exp(self)
    }
    
    @inlinable
    public var exp2: Self {
        return Foundation.exp2(self)
    }
    
    @inlinable
    public var expm1: Self {
        return Foundation.expm1(self)
    }
    
    @inlinable
    public var log: Self {
        return Foundation.log(self)
    }
    
    @inlinable
    public var log1p: Self {
        return Foundation.log1p(self)
    }
    
    @inlinable
    public var log2: Self {
        return Foundation.log2(self)
    }
    
    @inlinable
    public var log10: Self {
        return Foundation.log10(self)
    }
    
}

extension Float64 : TrigonometricTrait {
    
    @inlinable
    public var sin: Self {
        return Foundation.sin(self)
    }
    
    @inlinable
    public var asin: Self {
        return Foundation.asin(self)
    }
    
    @inlinable
    public var cos: Self {
        return Foundation.cos(self)
    }
    
    @inlinable
    public var acos: Self {
        return Foundation.acos(self)
    }
    
    @inlinable
    public var tan: Self {
        return Foundation.tan(self)
    }
    
    @inlinable
    public var atan: Self {
        return Foundation.atan(self)
    }
    
    @inlinable
    public func atan2(_ other: Self) -> Self {
        return Foundation.atan2(self, other)
    }
    
}
