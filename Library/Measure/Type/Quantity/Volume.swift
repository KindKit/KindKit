//
//  KindKit
//

import KindNumeric

public struct Volume : Quantity {
    
    public typealias Value = Unit.Value
    
    public let value: Value
    public let unit: Unit
    
    public init(value: Value, unit: Unit) {
        self.value = value
        self.unit = unit
    }
    
}

extension Volume : Hashable {
}

extension Volume : Equatable {
}

extension Volume : Sendable {
}
