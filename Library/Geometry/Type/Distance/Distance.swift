//
//  KindKit
//

import KindNumeric

public struct Distance : Hashable, Equatable {
    
    public var value: Coordinate
    
    public init(value: Coordinate) {
        self.value = value
    }
    
    public init< Input : ToNumberTrait >(_ input: Input) {
        self.value = input.to()
    }
    
}

public extension Distance {
    
    @inlinable
    var squared: SquaredDistance {
        return .init(self)
    }
    
}

public extension Distance {
    
    @inlinable
    init(_ input: SquaredDistance) {
        self.init(value: input.value.sqrt)
    }
    
}
