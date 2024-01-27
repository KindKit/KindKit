//
//  KindKit
//

public protocol RoundTrait {
    
    func rounded(_ rule: FloatingPointRoundingRule) -> Self
    
    func rounded(to digits: UInt) -> Self
    
    func truncated(to digits: UInt) -> Self
    
}

public extension RoundTrait {
    
    @inlinable
    var roundedUp: Self {
        return self.rounded(.awayFromZero)
    }
    
    @inlinable
    var roundedDown: Self {
        return self.rounded(.towardZero)
    }
    
    @inlinable
    var roundedNearest: Self {
        return self.rounded(.toNearestOrAwayFromZero)
    }
    
}

public extension RoundTrait where Self : MulTrait & DivTrait & PowerTrait {
    
    func rounded(to digits: UInt) -> Self {
        let d = Self.base(digits: digits)
        let t = self * d
        let r = t.roundedNearest
        return r / d
    }
    
    func truncated(to digits: UInt) -> Self {
        let d = Self.base(digits: digits)
        let t = self * d
        let r = t.roundedDown
        return r / d
    }
    
}
