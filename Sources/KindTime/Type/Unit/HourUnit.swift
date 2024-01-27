//
//  KindKit
//

import Foundation

public typealias HoursInterval = Interval< HourUnit >

public enum HourUnit: IUnit {
    
    public static var timeInterval: TimeInterval {
        return 3600
    }
    
}

public extension Interval {
    
    @inlinable
    var inHours: Interval< HourUnit > {
        return self.convert(to: HourUnit.self)
    }
    
}

public extension BinaryInteger {
    
    @inlinable
    var hours: Interval< HourUnit > {
        return .init(self)
    }
    
}

public extension BinaryFloatingPoint {
    
    @inlinable
    var hours: Interval< HourUnit > {
        return .init(self)
    }
    
}
