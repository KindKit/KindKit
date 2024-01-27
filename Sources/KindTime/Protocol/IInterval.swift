//
//  KindKit
//

import Foundation

public protocol IInterval {
    
    var timeInterval: TimeInterval { get }
    
    func convert< UnitType : IUnit >(to otherTimeUnit: UnitType.Type) -> Interval< UnitType >
    
}

public extension IInterval {
    
    @inlinable
    var dispatchTimeInterval: DispatchTimeInterval {
        return .milliseconds(Int(self.timeInterval * 1000))
    }
    
}
