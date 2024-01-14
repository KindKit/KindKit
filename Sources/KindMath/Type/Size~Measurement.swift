//
//  KindKit
//

import Foundation

public extension Size {
    
    init(
        width: Measurement< UnitLength >,
        height: Measurement< UnitLength >
    ) {
        self.width = width.kk_value(to: .millimeters)
        self.height = height.kk_value(to: .millimeters)
    }
    
    init(
        width: Double,
        height: Double,
        unit: UnitLength
    ) {
        self.init(
            width: Measurement(value: width, unit: unit),
            height: Measurement(value: height, unit: unit)
        )
    }
    
    @inlinable
    func to(width unit: UnitLength) -> Measurement< UnitLength > {
        let measurement = Measurement(value: self.width, unit: UnitLength.millimeters)
        guard unit != .millimeters else { return measurement }
        return measurement.converted(to: unit)
    }
    
    @inlinable
    func to(height unit: UnitLength) -> Measurement< UnitLength > {
        let measurement = Measurement(value: self.height, unit: UnitLength.millimeters)
        guard unit != .millimeters else { return measurement }
        return measurement.converted(to: unit)
    }

}
