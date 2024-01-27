//
//  KindKit
//

import Foundation

public typealias NanosecondsInterval = Interval< NanosecondUnit >

public enum NanosecondUnit: IUnit {
    
    public static var timeInterval: TimeInterval {
        return 1e-9
    }
    
}

public extension Interval {
    
    @inlinable
    var inNanoseconds: Interval< NanosecondUnit > {
        return self.convert(to: NanosecondUnit.self)
    }
    
}

public extension BinaryInteger {
    
    @inlinable
    var nanoseconds: Interval< NanosecondUnit > {
        return .init(self)
    }
    
}

public extension BinaryFloatingPoint {
    
    @inlinable
    var nanoseconds: Interval< NanosecondUnit > {
        return .init(self)
    }
    
}
