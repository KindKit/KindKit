//
//  KindKit
//

import Foundation

public struct ExponencialInEase : IEase {
    
    public init() {
    }

    public func perform(_ x: Double) -> Double {
        return (x == 0) ? x : pow(2, 10 * (x - 1))
    }

}

public struct ExponencialOutEase : IEase {
    
    public init() {
    }

    public func perform(_ x: Double) -> Double {
        return (x == 1) ? x : 1 - pow(2, -10 * x)
    }

}

public struct ExponencialInOutEase : IEase {
    
    public init() {
    }

    public func perform(_ x: Double) -> Double {
        if x == 0 || x == 1 { return x }
        if x < 1 / 2 {
            return 1 / 2 * pow(2, (20 * x) - 10)
        } else {
            let h = pow(2, (-20 * x) + 10)
            return -1 / 2 * h + 1
        }
    }

}
