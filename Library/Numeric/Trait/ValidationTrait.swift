//
//  KindKit
//

public protocol ValidationTrait {
    
    var isValid: Bool { get }
    
    var validated: Self { get }
    
}

public extension ValidationTrait {
    
    @inlinable
    var isNotValid: Bool {
        return !self.isValid
    }
    
}

public extension ValidationTrait {
    
    @inlinable
    func validated(default block: () -> Self) -> Self {
        return self.isValid == true ? self : block()
    }
    
    @inlinable
    func validated(default block: @autoclosure () -> Self) -> Self {
        return self.isValid == true ? self : block()
    }
    
    @inlinable
    func validated(modify block: (Self) -> Self) -> Self {
        return self.isValid == true ? block(self) : self
    }
    
}

public extension ValidationTrait where Self : InfinityTrait & NaNTrait {
    
    @inlinable
    var isValid: Bool {
        return self.isInfinite == false && self.isNaN == false
    }
    
}
