//
//  KindKit
//

import Foundation

public typealias SecondsInterval = Interval< SecondUnit >

public enum SecondUnit: IUnit {
    
    public static var timeInterval: TimeInterval {
        return 1
    }
    
}

public extension Interval {
    
    @inlinable
    var inSeconds: Interval< SecondUnit > {
        return self.convert(to: SecondUnit.self)
    }
    
}

public extension BinaryInteger {
    
    @inlinable
    var seconds: Interval< SecondUnit > {
        return .init(self)
    }
    
}

public extension BinaryFloatingPoint {
    
    @inlinable
    var seconds: Interval< SecondUnit > {
        return .init(self)
    }
    
}
