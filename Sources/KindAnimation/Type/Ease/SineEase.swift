//
//  KindKit
//

import Foundation

public struct SineInEase : IEase {
    
    public init() {
    }

    public func perform(_ x: Double) -> Double {
        return (sin((x - 1) * .pi / 2) ) + 1
    }

}

public struct SineOutEase : IEase {
    
    public init() {
    }

    public func perform(_ x: Double) -> Double {
        return sin(x * .pi / 2)
    }

}

public struct SineInOutEase : IEase {
    
    public init() {
    }

    public func perform(_ x: Double) -> Double {
        return 1 / 2 * (1 - cos(x * .pi))
    }

}
