//
//  KindKit
//

import KindNumeric

public struct Radian {
    
    public var value: Coordinate
    
    public init(value: Coordinate) {
        self.value = value
    }
    
    public init< Input : ToNumberTrait >(from input: Input) {
        self.value = input.to()
    }
    
}

extension Radian : Hashable {
}

extension Radian : Equatable {
}

extension Radian : Sendable {
}

public extension Radian {
    
    @inlinable
    static var degrees0: Self {
        return .init(value: 0)
    }
    
    @inlinable
    static var degrees45: Self {
        return .init(value: .pi / 4)
    }
    
    @inlinable
    static var degrees90: Self {
        return .init(value: .pi / 2)
    }
    
    @inlinable
    static var degrees135: Self {
        return .init(value: (3 * .pi) / 4)
    }
    
    @inlinable
    static var degrees180: Self {
        return .init(value: .pi)
    }
    
    @inlinable
    static var degrees225: Self {
        return .init(value: (5 * .pi) / 4)
    }
    
    @inlinable
    static var degrees270: Self {
        return .init(value: (3 * .pi) / 2)
    }
    
    @inlinable
    static var degrees315: Self {
        return .init(value: (7 * .pi) / 4)
    }
    
    @inlinable
    static var degrees360: Self {
        return .init(value: .pi * 2)
    }
    
}
