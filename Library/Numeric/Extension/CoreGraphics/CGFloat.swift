//
//  KindKit
//

#if canImport(CoreGraphics)

import CoreGraphics
import KindCore

extension CGFloat : FromNumberTrait {}

extension CGFloat : ToNumberTrait {}

extension CGFloat : EpsilonTrait {}

extension CGFloat : InfinityTrait {}

extension CGFloat : NaNTrait {}

extension CGFloat : ZeroTrait {}

extension CGFloat : OneTrait {}

extension CGFloat : MinTrait {
    
    public static var min: Self {
        return -Self.NativeType.min
    }
    
}

extension CGFloat : MaxTrait {
    
    public static var max: Self {
        return -Self.NativeType.max
    }
    
}

extension CGFloat : AddTrait {}

extension CGFloat : AddNumberTrait {}

extension CGFloat : AddPercentTrait {}

extension CGFloat : SubTrait {}

extension CGFloat : SubNumberTrait {}

extension CGFloat : SubPercentTrait {}

extension CGFloat : MulTrait {}

extension CGFloat : MulNumberTrait {}

extension CGFloat : MulPercentTrait {}

extension CGFloat : DivTrait {}

extension CGFloat : DivNumberTrait {}

extension CGFloat : NegativeTrait {}

extension CGFloat : NearCompareTrait {}

extension CGFloat : NearEqualTrait {}

extension CGFloat : NormalizeTrait {
    
    public typealias NormalizedType = Self
    
}

extension CGFloat : ValidationTrait {
    
    @inlinable
    public var validated: Self {
        return .zero
    }
    
}

extension CGFloat : LerpTrait {}

#endif
