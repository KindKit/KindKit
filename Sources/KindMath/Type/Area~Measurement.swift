//
//  KindKit
//

import Foundation

public extension Area {
    
    init(_ value: Measurement< UnitArea >) {
        self.value = value.kk_value(to: .squareMillimeters)
    }
    
    init(_ value: Double, unit: UnitArea) {
        self.init(Measurement(value: value, unit: unit))
    }
    
    @inlinable
    func to(unit: UnitArea) -> Measurement< UnitArea > {
        let measurement = Measurement(value: self.value, unit: UnitArea.squareMillimeters)
        guard unit != .squareMillimeters else { return measurement }
        return measurement.converted(to: unit)
    }

}
