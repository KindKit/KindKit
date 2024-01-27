//
//  KindKit
//

import Foundation

public struct CircularInEase : Ease {
    
    public init() {
    }

    public func perform(_ x: Double) -> Double {
        return 1.0 - sqrt(1.0 - (x * x))
    }

}

public struct CircularOutEase : Ease {
    
    public init() {
    }

    public func perform(_ x: Double) -> Double {
        return sqrt((2.0 - x) * x)
    }

}

public struct CircularInOutEase : Ease {
    
    public init() {
    }

    public func perform(_ x: Double) -> Double {
        if x < 0.5 {
            let h = 1.0 - sqrt(1.0 - 4.0 * (x * x))
            return 0.5 * h
        } else {
            let f = -((2.0 * x) - 3.0) * ((2.0 * x) - 1.0)
            let g = sqrt(f)
            return 0.5 * (g + 1.0)
        }
    }

}
