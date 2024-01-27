//
//  KindKit
//

import KindNumeric

public struct Length : Quantity {
    
    public typealias Value = Unit.Value
    
    public let value: Value
    public let unit: Unit
    
    public init(value: Value, unit: Unit) {
        self.value = value
        self.unit = unit
    }
    
}

extension Length : Hashable {
}

extension Length : Equatable {
}

extension Length : Sendable {
}

extension Length : MulExTrait {
    
    @inlinable
    public func multiplying(by other: Self) -> Area {
        return .init(
            value: self.value * other.value(to: self.unit),
            unit: .init(super: self.unit)
        )
    }
    
}
