//
//  KindKit
//

import Foundation

public extension Point {
    
    @inlinable
    func x(unit: UnitLength) -> Measurement< UnitLength > {
        return .init(value: self.x, unit: unit)
    }
    
    @inlinable
    func y(unit: UnitLength) -> Measurement< UnitLength > {
        return .init(value: self.y, unit: unit)
    }

}
