//
//  KindKit
//

import Foundation

public struct ElasticInEase : Ease {
    
    public init() {
    }

    public func perform(_ x: Double) -> Double {
        return sin(13.0 * .pi / 2.0 * x) * pow(2.0, 10.0 * (x - 1.0))
    }

}

public struct ElasticOutEase : Ease {
    
    public init() {
    }

    public func perform(_ x: Double) -> Double {
        let f = sin(-13.0 * .pi / 2.0 * (x + 1.0))
        let g = pow(2.0, -10.0 * x)
        return f * g + 1.0
    }

}

public struct ElasticInOutEase : Ease {
    
    public init() {
    }

    public func perform(_ x: Double) -> Double {
        if x < 0.5 {
            let f = sin(13.0 * .pi / 2.0 * (2.0 * x))
            return 0.5 * f * pow(2.0, 10.0 * (2.0 * x) - 1.0)
        } else {
            let h = (2.0 * x - 1.0) + 1.0
            let f = sin(-13.0 * .pi / 2.0 * h)
            let g = pow(2.0, -10.0 * (2.0 * x - 1.0))
            return 0.5 * (f * g + 2.0)
        }
    }

}
