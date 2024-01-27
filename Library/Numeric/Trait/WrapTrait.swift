//
//  KindKit
//

public protocol WrapTrait {
	
    func wrap(_ lower: Self, _ upper: Self) -> Self
    
}

public extension WrapTrait where Self : Comparable & AddTrait & SubTrait {
    
    @inlinable
    func wrap(_ lower: Self, _ upper: Self) -> Self {
        let delta = upper - lower
        var result = self
        while result <= lower {
            result += delta
        }
        while result >= upper {
            result -= delta
        }
        return result
    }
    
}
