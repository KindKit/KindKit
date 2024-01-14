//
//  KindKit
//

import Foundation

public extension Angle {
    
    init(_ value: Measurement< UnitAngle >) {
        self.radians = value.kk_value(to: UnitAngle.radians)
    }
    
    init(_ value: Double, unit: UnitAngle) {
        self.init(Measurement(value: value, unit: unit))
    }

    @inlinable
    func to(unit: UnitAngle) -> Measurement< UnitAngle > {
        let measurement = Measurement(value: self.radians, unit: UnitAngle.radians)
        guard unit != .radians else { return measurement }
        return measurement.converted(to: unit)
    }

}
