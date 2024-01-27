//
//  KindKit
//

import KindTime

public struct ClockTick< UnitType : IUnit > : Equatable {
    
    public let duration: Interval< UnitType >
    public var elapsed: Interval< UnitType >
    
}

public extension ClockTick {
    
    @inlinable
    var remainder: Interval< UnitType > {
        return self.duration - self.elapsed
    }
    
}
