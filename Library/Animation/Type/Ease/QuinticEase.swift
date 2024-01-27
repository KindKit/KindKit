//
//  KindKit
//

import Foundation

public struct QuinticInEase : Ease {
    
    public init() {
    }

    public func perform(_ x: Double) -> Double {
        return x * x * x * x * x
    }

}

public struct QuinticOutEase : Ease {
    
    public init() {
    }

    public func perform(_ x: Double) -> Double {
        let f = x - 1.0
        return f * f * f * f * f + 1.0
    }

}

public struct QuinticInOutEase : Ease {
    
    public init() {
    }

    public func perform(_ x: Double) -> Double {
        if x < 0.5 {
            return 16.0 * x * x * x * x * x
        } else {
            let f = (2.0 * x) - 2.0
            return  0.5 * f * f * f * f * f + 1.0
        }
    }

}
