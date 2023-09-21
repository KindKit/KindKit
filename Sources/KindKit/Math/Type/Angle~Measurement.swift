//
//  KindKit
//

import Foundation

public extension Angle {
    
    @inlinable
    func angle(unit: UnitAngle) -> Measurement< UnitAngle > {
        let radians = Measurement(value: self.radians, unit: UnitAngle.radians)
        guard unit != .radians else { return radians }
        return radians.converted(to: unit)
    }

}
