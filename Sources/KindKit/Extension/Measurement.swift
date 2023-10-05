//
//  KindKit
//

import Foundation

public extension Measurement where UnitType : Dimension {
    
    @inlinable
    func kk_value(to unit: UnitType) -> Double {
        return self.converted(to: unit).value
    }
    
}

public extension Measurement where UnitType : Dimension {
    
    @inlinable
    var kk_abs: Self {
        return .init(
            value: Foundation.fabs(self.value),
            unit: self.unit
        )
    }
    
    @inlinable
    var kk_sqrt: Self {
        return .init(
            value: Foundation.sqrt(self.value),
            unit: self.unit
        )
    }
    
    @inlinable
    var kk_pow2: Self {
        return .init(
            value: Foundation.pow(self.value, 2),
            unit: self.unit
        )
    }
    
    @inlinable
    func kk_pow(_ other: Self) -> Self {
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

    func kk_isEqual(_ other: Self, tolerance: Self) -> Bool {
        let delta = self - other
        return delta.kk_abs < tolerance
    }
    
    func kk_isNotEqual(_ other: Self, tolerance: Self) -> Bool {
        return self.kk_isEqual(other, tolerance: tolerance) == false
    }
    
}

extension Measurement : INearEqutable where UnitType : Dimension {
    
    public static func ~~ (lhs: Self, rhs: Self) -> Bool {
        let lvalue, rvalue: Double
        if lhs.unit != rhs.unit {
            lvalue = lhs.value
            rvalue = rhs.converted(to: lhs.unit).value
        } else {
            lvalue = lhs.value
            rvalue = rhs.value
        }
        return lvalue ~~ rvalue
    }
    
}

