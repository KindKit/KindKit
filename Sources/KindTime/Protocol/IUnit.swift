//
//  KindKit
//

import Foundation

public protocol IUnit {
    
    static var timeInterval: TimeInterval { get }
    
}

public extension IUnit {
    
    @inlinable
    static func ratio< UnitType : IUnit >(to: UnitType.Type) -> TimeInterval {
        return Self.timeInterval / UnitType.timeInterval
    }
    
}
