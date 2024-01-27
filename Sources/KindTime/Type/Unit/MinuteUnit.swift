//
//  KindKit
//

import Foundation

public typealias MinutesInterval = Interval< MinuteUnit >

public enum MinuteUnit: IUnit {
    
    public static var timeInterval: TimeInterval {
        return 60
    }

}

public extension Interval {
    
    @inlinable
    var inMinutes: Interval< MinuteUnit > {
        return self.convert(to: MinuteUnit.self)
    }
    
}

public extension BinaryInteger {
    
    @inlinable
    var minutes: Interval< MinuteUnit > {
        return .init(self)
    }
    
}

public extension BinaryFloatingPoint {
    
    @inlinable
    var minutes: Interval< MinuteUnit > {
        return .init(self)
    }
    
}
