//
//  KindKit
//

import Foundation

public struct BounceInEase : Ease {

    private let _out = BounceOutEase()

    public init() {
    }

    public func perform(_ x: Double) -> Double {
        return 1.0 - self._out.perform(1.0 - x)
    }

}

public struct BounceOutEase : Ease {
    
    public init() {
    }

    public func perform(_ x: Double) -> Double {
        if x < 4.0 / 11.0 {
            return (121.0 * x * x) / 16.0
        } else if x < 8.0 / 11.0 {
            let f = (363.0 / 40.0) * x * x
            let g = (99.0 / 10.0) * x
            return f - g + (17.0 / 5.0)
        } else if x < 9.0 / 10.0 {
            let f = (4356.0 / 361.0) * x * x
            let g = (35442.0 / 1805.0) * x
            return  f - g + (16061.0 / 1805.0)
        } else {
            let f = (54.0 / 5.0) * x * x
            return f - ((513.0 / 25.0) * x) + 268.0 / 25.0
        }
    }

}

public struct BounceInOutEase : Ease {

    private let _in = BounceInEase()
    private let _out = BounceOutEase()

    public init() {
    }

    public func perform(_ x: Double) -> Double {
        if x < 0.5 {
            return 0.5 * self._in.perform(x * 2.0)
        } else {
            let f = self._out.perform(x * 2.0 - 1.0) + 1.0
            return 0.5 * f
        }
    }

}
