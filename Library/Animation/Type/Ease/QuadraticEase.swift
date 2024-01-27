//
//  KindKit
//

import Foundation

public struct QuadraticInEase : Ease {
    
    public init() {
    }

    public func perform(_ x: Double) -> Double {
        return x * x
    }

}

public struct QuadraticOutEase : Ease {
    
    public init() {
    }

    public func perform(_ x: Double) -> Double {
        return -(x * (x - 2.0))
    }

}

public struct QuadraticInOutEase : Ease {
    
    public init() {
    }

    public func perform(_ x: Double) -> Double {
        if x < 0.5 {
            return 2.0 * x * x
        } else {
            return (-2.0 * x * x) + (4.0 * x) - 1.0
        }
    }

}
