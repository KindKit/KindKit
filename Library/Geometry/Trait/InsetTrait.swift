//
//  KindKit
//

public protocol InsetTrait {
    
    func inset(_ inset: Inset) -> Self
    
}

public extension InsetTrait {
    
    func inset(_ inset: Coordinate) -> Self {
        return self.inset(.init(all: inset))
    }
    
}
