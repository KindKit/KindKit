//
//  KindKit
//

import Foundation

public struct QuadraticInEase : IEase {
    
    public init() {
    }

    public func perform(_ x: Double) -> Double {
        return x * x
    }

}

public struct QuadraticOutEase : IEase {
    
    public init() {
    }

    public func perform(_ x: Double) -> Double {
        return -(x * (x - 2))
    }

}

public struct QuadraticInOutEase : IEase {
    
    public init() {
    }

    public func perform(_ x: Double) -> Double {
        if x < 1 / 2 {
            return 2 * x * x
        } else {
            return (-2 * x * x) + (4 * x) - 1
        }
    }

}
