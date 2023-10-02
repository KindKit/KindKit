//
//  KindKit
//

import Foundation

public extension Angle {
    
    init(_ value: Measurement< UnitAngle >) {
        self.radians = value.value(to: UnitAngle.radians)
    }

    @inlinable
    func angle(unit: UnitAngle) -> Measurement< UnitAngle > {
        let radians = Measurement(value: self.radians, unit: UnitAngle.radians)
        guard unit != .radians else { return radians }
        return radians.converted(to: unit)
    }

}
