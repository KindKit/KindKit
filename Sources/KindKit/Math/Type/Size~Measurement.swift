//
//  KindKit
//

import Foundation

public extension Size {
    
    @inlinable
    func width(unit: UnitLength) -> Measurement< UnitLength > {
        return .init(value: self.width, unit: unit)
    }
    
    @inlinable
    func height(unit: UnitLength) -> Measurement< UnitLength > {
        return .init(value: self.height, unit: unit)
    }

}
