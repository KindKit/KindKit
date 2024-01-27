//
//  KindKit
//

public protocol NormalizeTrait {
    
    associatedtype Normalized
    
    var canNormalize: Bool { get }
    
    var normalized: Normalized { get }
    
}

public extension NormalizeTrait where Self : ZeroTrait, Self == Normalized {
    
    @inlinable
    var normalized: Normalized {
        return self.canNormalize == true ? .zero : self
    }
    
}

public extension NormalizeTrait where Self : InfinityTrait & NaNTrait, Self == Normalized {
    
    @inlinable
    var canNormalize: Bool {
        return self.isInfinite == true || self.isNaN == true
    }
    
}
