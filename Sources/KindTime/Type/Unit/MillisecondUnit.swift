//
//  KindKit
//

import Foundation

public typealias MillisecondsInterval = Interval< MillisecondUnit >

public enum MillisecondUnit: IUnit {
    
    public static var timeInterval: TimeInterval {
        return 0.001
    }
    
}

public extension Interval {
    
    @inlinable
    var inMilliseconds: Interval< MillisecondUnit > {
        return self.convert(to: MillisecondUnit.self)
    }
    
}

public extension BinaryInteger {
    
    @inlinable
    var milliseconds: Interval< MillisecondUnit > {
        return .init(self)
    }
    
}

public extension BinaryFloatingPoint {
    
    @inlinable
    var milliseconds: Interval< MillisecondUnit > {
        return .init(self)
    }
    
}
