//
//  KindKit
//

import KindNumeric

public struct Area : Quantity {
    
    public typealias Value = Unit.Value
    
    public let value: Value
    public let unit: Unit
    
    public init(value: Value, unit: Unit) {
        self.value = value
        self.unit = unit
    }
    
}

extension Area : Hashable {
}

extension Area : Equatable {
}

extension Area : Sendable {
}

extension Area : MulExTrait {
    
    @inlinable
    public func multiplying(by other: Length) -> Volume {
        let area = Area(
            value: self.value.multiplying(by: other.value(as: self.unit)),
            unit: self.unit
        )
        return .init(
            value: area.base.value,
            unit: .base
        )
    }
    
}
