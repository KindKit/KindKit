//
//  KindKit
//

import Foundation

public extension Point {
    
    init(
        x: Measurement< UnitLength >,
        y: Measurement< UnitLength >
    ) {
        self.x = x.kk_value(to: .millimeters)
        self.y = y.kk_value(to: .millimeters)
    }
    
    init(
        x: Double,
        y: Double,
        unit: UnitLength
    ) {
        self.init(
            x: Measurement(value: x, unit: unit),
            y: Measurement(value: y, unit: unit)
        )
    }
    
    @inlinable
    func to(x unit: UnitLength) -> Measurement< UnitLength > {
        let measurement = Measurement(value: self.x, unit: UnitLength.millimeters)
        guard unit != .millimeters else { return measurement }
        return measurement.converted(to: unit)
    }
    
    @inlinable
    func to(y unit: UnitLength) -> Measurement< UnitLength > {
        let measurement = Measurement(value: self.y, unit: UnitLength.millimeters)
        guard unit != .millimeters else { return measurement }
        return measurement.converted(to: unit)
    }

}
