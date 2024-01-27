//
//  KindKit
//

public protocol ResolveTrait : Equatable {
    
    associatedtype Resolve : ResolveTrait
    
    func resolve(_ states: States) -> Resolve
    
}

public extension ResolveTrait {
    
    @inlinable
    func resolve(_ states: States) -> Self {
        return self
    }
    
}
