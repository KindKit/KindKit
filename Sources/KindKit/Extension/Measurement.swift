//
//  KindKit
//

import Foundation

public extension Measurement where UnitType : Dimension {
    
    @inlinable
    func value(to unit: UnitType) -> Double {
        return self.converted(to: unit).value
    }
    
}

public extension Measurement where UnitType : Dimension {
    
    @inlinable
    var abs: Self {
        return .init(
            value: Foundation.fabs(self.value),
            unit: self.unit
        )
    }
    
    @inlinable
    var sqrt: Self {
        return .init(
            value: Foundation.sqrt(self.value),
            unit: self.unit
        )
    }
    
    @inlinable
    var pow2: Self {
        return .init(
            value: Foundation.pow(self.value, 2),
            unit: self.unit
        )
    }
    
    @inlinable
    func pow(_ other: Self) -> Self {
        let lhs = self.unit.converter.baseUnitValue(fromValue: self.value)
        let rhs = other.unit.converter.baseUnitValue(fromValue: other.value)
        return .init(
            value: self.unit.converter.value(
                fromBaseUnitValue: Foundation.pow(lhs, rhs)
            ),
            unit: self.unit
        )
    }
    
}

public extension Measurement where UnitType : Dimension {

    func isEqual(_ other: Self, tolerance: Self) -> Bool {
        let delta = self - other
        return delta.abs < tolerance
    }
    
    func isNotEqual(_ other: Self, tolerance: Self) -> Bool {
        return self.isEqual(other, tolerance: tolerance) == false
    }
    
}
