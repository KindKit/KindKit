//
//  KindKit
//

import KindNumeric

public struct SquaredDistance : Hashable, Equatable {
    
    public var value: Coordinate
    
    public init(value: Coordinate) {
        self.value = value
    }
    
    public init< Input : ToNumberTrait >(_ input: Input) {
        self.value = input.to()
    }
    
}

public extension SquaredDistance {
    
    @inlinable
    var distance: Distance {
        return .init(self)
    }
    
}

public extension SquaredDistance {
    
    @inlinable
    init(_ input: Distance) {
        self.init(input.value * input.value)
    }
    
}
