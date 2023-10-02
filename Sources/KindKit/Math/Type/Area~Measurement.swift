//
//  KindKit
//

import Foundation

public extension Area {
    
    init(_ value: Measurement< UnitArea >) {
        self.value = value.value
    }
    
    @inlinable
    func area(unit: UnitArea) -> Measurement< UnitArea > {
        return Measurement(value: self.value, unit: unit)
    }

}
