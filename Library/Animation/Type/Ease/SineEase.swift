//
//  KindKit
//

import Foundation

public struct SineInEase : Ease {
    
    public init() {
    }

    public func perform(_ x: Double) -> Double {
        return (sin((x - 1.0) * .pi / 2.0) ) + 1.0
    }

}

public struct SineOutEase : Ease {
    
    public init() {
    }

    public func perform(_ x: Double) -> Double {
        return sin(x * .pi / 2.0)
    }

}

public struct SineInOutEase : Ease {
    
    public init() {
    }

    public func perform(_ x: Double) -> Double {
        return 0.5 * (1.0 - cos(x * .pi))
    }

}
