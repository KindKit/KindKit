//
//  KindKit
//

import Foundation

public extension Distance {
    
    @inlinable
    func distance(unit: UnitLength) -> Measurement< UnitLength > {
        return Measurement(value: self.value, unit: unit)
    }

}
