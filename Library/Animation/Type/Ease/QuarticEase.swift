//
//  KindKit
//

import Foundation

public struct QuarticInEase : Ease {
    
    public init() {
    }

    public func perform(_ x: Double) -> Double {
        return x * x * x * x
    }

}

public struct QuarticOutEase : Ease {
    
    public init() {
    }

    public func perform(_ x: Double) -> Double {
        let f = x - 1.0
        return f * f * f * (1.0 - x) + 1.0
    }

}

public struct QuarticInOutEase : Ease {
    
    public init() {
    }

    public func perform(_ x: Double) -> Double {
        if x < 0.5 {
            return 8.0 * x * x * x * x
        } else {
            let f = (x - 1.0)
            return -8.0 * f * f * f * f + 1.0
        }
    }

}
