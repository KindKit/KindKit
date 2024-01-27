//
//  KindKit
//

import Foundation

public struct BackInEase : Ease {
    
    public init() {
    }

    public func perform(_ x: Double) -> Double {
        return x * x * x - x * sin(x * .pi)
    }

}

public struct BackOutEase : Ease {
    
    private let _ease = BackInEase()
    
    public init() {
    }

    public func perform(_ x: Double) -> Double {
        return 1.0 - self._ease.perform(1.0 - x)
    }

}

public struct BackInOutEase : Ease {
    
    public init() {
    }

    public func perform(_ x: Double) -> Double {
        if x < 0.5 {
            let f = 2.0 * x
            return 0.5 * (f * f * f - f * sin(f * .pi))
        } else {
            let f = 1.0 - (2.0 * x - 1.0)
            let g = sin(f * .pi)
            let h = (f * f * f - f * g)
            return 0.5 * (1.0 - h) + 0.5
        }
    }

}
