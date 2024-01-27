//
//  KindKit
//

import Foundation

public typealias MicrosecondsInterval = Interval< MicrosecondUnit >

public enum MicrosecondUnit: IUnit {
    
    public static var timeInterval: TimeInterval {
        return 0.000001
    }
    
}

public extension Interval {
    
    @inlinable
    var inMicroseconds: Interval< MicrosecondUnit > {
        return self.convert(to: MicrosecondUnit.self)
    }
    
}

public extension BinaryInteger {
    
    @inlinable
    var microseconds: Interval< MicrosecondUnit > {
        return .init(self)
    }
    
}

public extension BinaryFloatingPoint {
    
    @inlinable
    var microseconds: Interval< MicrosecondUnit > {
        return .init(self)
    }
    
}
