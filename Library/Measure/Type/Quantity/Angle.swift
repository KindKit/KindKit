//
//  KindKit
//

import KindNumeric

public struct Angle : Quantity {
    
    public typealias Value = Unit.Value
    
    public let value: Value
    public let unit: Unit
    
    public init(value: Value, unit: Unit) {
        self.value = value
        self.unit = unit
    }
    
}

extension Angle : Hashable {
}

extension Angle : Equatable {
}

extension Angle : Sendable {
}

public extension Angle {
    
    @inlinable
    static var min: Self {
        return .init(value: -1, unit: .base)
    }
    
    @inlinable
    static var max: Self {
        return .init(value: 1, unit: .base)
    }
    
}

extension Angle : ValidationTrait {
    
    @inlinable
    public var isValid: Bool {
        return self.isWithin(.min, .max)
    }
    
    @inlinable
    public var validated: Self {
        var value = self.value
        do {
            let limit = Self.min.value(to: self.unit)
            while value <= limit {
                value -= limit
            }
        }
        do {
            let limit = Self.max.value(to: self.unit)
            while value >= limit {
                value -= limit
            }
        }
        return .init(value: value, unit: self.unit)
    }
    
}
