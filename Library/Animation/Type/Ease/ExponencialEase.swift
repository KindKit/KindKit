//
//  KindKit
//

import Foundation

public struct ExponencialInEase : Ease {
    
    public init() {
    }

    public func perform(_ x: Double) -> Double {
        return (x == 0.0) ? x : pow(2.0, 10.0 * (x - 1.0))
    }

}

public struct ExponencialOutEase : Ease {
    
    public init() {
    }

    public func perform(_ x: Double) -> Double {
        return (x == 1.0) ? x : 1.0 - pow(2.0, -10.0 * x)
    }

}

public struct ExponencialInOutEase : Ease {
    
    public init() {
    }

    public func perform(_ x: Double) -> Double {
        if x == 0.0 || x == 1.0 { return x }
        if x < 0.5 {
            return 0.5 * pow(2.0, (20.0 * x) - 10.0)
        } else {
            let h = pow(2.0, (-20.0 * x) + 10.0)
            return -0.5 * h + 1.0
        }
    }

}
