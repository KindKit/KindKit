//
//  KindKit
//

import Foundation

public struct ElasticInEase : IEase {
    
    public init() {
    }

    public func perform(_ x: Double) -> Double {
        return sin(13 * .pi / 2 * x) * pow(2, 10 * (x - 1))
    }

}

public struct ElasticOutEase : IEase {
    
    public init() {
    }

    public func perform(_ x: Double) -> Double {
        let f = sin(-13 * .pi / 2 * (x + 1))
        let g = pow(2, -10 * x)
        return f * g + 1
    }

}

public struct ElasticInOutEase : IEase {
    
    public init() {
    }

    public func perform(_ x: Double) -> Double {
        if x < 1 / 2 {
            let f = sin(13 * .pi / 2 * (2 * x))
            return 1 / 2 * f * pow(2, 10 * (2 * x) - 1)
        } else {
            let h = (2 * x - 1) + 1
            let f = sin(-13 * .pi / 2 * h)
            let g = pow(2, -10 * (2 * x - 1))
            return 1 / 2 * (f * g + 2)
        }
    }

}
