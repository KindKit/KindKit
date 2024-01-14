//
//  KindKit
//

import Foundation

public extension Distance {
    
    init(_ value: Measurement< UnitLength >) {
        self.value = value.kk_value(to: .millimeters)
    }
    
    init(_ value: Double, unit: UnitLength) {
        self.init(Measurement(value: value, unit: unit))
    }
    
    @inlinable
    func to(unit: UnitLength) -> Measurement< UnitLength > {
        let measurement = Measurement(value: self.value, unit: UnitLength.millimeters)
        guard unit != .millimeters else { return measurement }
        return measurement.converted(to: unit)
    }

}
