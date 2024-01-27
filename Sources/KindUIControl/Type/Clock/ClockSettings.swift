//
//  KindKit
//

import KindTime

public struct ClockSettings< UnitType : IUnit > : Equatable {
    
    public let tolerance: Interval< UnitType >
    public let interval: Interval< UnitType >
    public let iterations: Int
    
    public init(
        tolerance: Interval< UnitType > = .zero,
        interval: Interval< UnitType >,
        iterations: Int
    ) {
        self.tolerance = tolerance
        self.interval = interval
        self.iterations = iterations
    }
    
}

public extension ClockSettings {
    
    @inlinable
    var duration: Interval< UnitType > {
        return self.interval * Interval< UnitType >(self.iterations)
    }
    
}
