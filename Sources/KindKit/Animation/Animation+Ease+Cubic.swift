//
//  KindKit
//

import Foundation

public extension Animation.Ease {

    struct CubicIn : IAnimationEase {
        
        public init() {
        }

        public func perform(_ x: Double) -> Double {
            return x * x * x
        }

    }

    struct CubicOut : IAnimationEase {
        
        public init() {
        }

        public func perform(_ x: Double) -> Double {
            let p = x - 1
            return  p * p * p + 1
        }

    }

    struct CubicInOut : IAnimationEase {
        
        public init() {
        }

        public func perform(_ x: Double) -> Double {
            if x < 1/2 {
                return 4 * x * x * x
            } else {
                let f = ((2 * x) - 2)
                return 1/2 * f * f * f + 1
            }
        }

    }

}

public extension IAnimationEase where Self == Animation.Ease.CubicIn {
    
    @inlinable
    static func cubicIn() -> Self {
        return .init()
    }
    
}

public extension IAnimationEase where Self == Animation.Ease.CubicOut {
    
    @inlinable
    static func cubicOut() -> Self {
        return .init()
    }
    
}

public extension IAnimationEase where Self == Animation.Ease.CubicInOut {
    
    @inlinable
    static func cubicInOut() -> Self {
        return .init()
    }
    
}
