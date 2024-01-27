//
//  KindKit
//

import Foundation

public struct CubicInEase : Ease {
    
    public init() {
    }

    public func perform(_ x: Double) -> Double {
        return x * x * x
    }

}

public struct CubicOutEase : Ease {
    
    public init() {
    }

    public func perform(_ x: Double) -> Double {
        let p = x - 1.0
        return  p * p * p + 1.0
    }

}

public struct CubicInOutEase : Ease {
    
    public init() {
    }

    public func perform(_ x: Double) -> Double {
        if x < 0.5 {
            return 4.0 * x * x * x
        } else {
            let f = ((2.0 * x) - 2.0)
            return 0.5 * f * f * f + 1.0
        }
    }

}
