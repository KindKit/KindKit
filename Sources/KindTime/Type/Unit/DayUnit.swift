//
//  KindKit
//

import Foundation

public typealias DaysInterval = Interval< DayUnit >

public enum DayUnit: IUnit {
    
    public static var timeInterval: TimeInterval {
        return 86400
    }
    
}

public extension Interval {
    
    @inlinable
    var inDays: Interval< DayUnit > {
        return self.convert(to: DayUnit.self)
    }
    
}

public extension BinaryInteger {
    
    @inlinable
    var days: Interval< DayUnit > {
        return .init(self)
    }
    
}

public extension BinaryFloatingPoint {
    
    @inlinable
    var days: Interval< DayUnit > {
        return .init(self)
    }
    
}
