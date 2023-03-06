//
//  KindKit
//

import Foundation

public extension Animation.Ease {

    struct QuarticIn : IAnimationEase {
        
        public init() {
        }

        public func perform(_ x: Double) -> Double {
            return x * x * x * x
        }

    }

    struct QuarticOut : IAnimationEase {
        
        public init() {
        }

        public func perform(_ x: Double) -> Double {
            let f = x - 1
            return f * f * f * (1 - x) + 1
        }

    }

    struct QuarticInOut : IAnimationEase {
        
        public init() {
        }

        public func perform(_ x: Double) -> Double {
            if x < 1/2 {
                return 8 * x * x * x * x
            } else {
                let f = (x - 1)
                return -8 * f * f * f * f + 1
            }
        }

    }

}

public extension IAnimationEase where Self == Animation.Ease.QuarticIn {
    
    @inlinable
    static func quarticIn() -> Self {
        return .init()
    }
    
}

public extension IAnimationEase where Self == Animation.Ease.QuarticOut {
    
    @inlinable
    static func quarticOut() -> Self {
        return .init()
    }
    
}

public extension IAnimationEase where Self == Animation.Ease.QuarticInOut {
    
    @inlinable
    static func quarticInOut() -> Self {
        return .init()
    }
    
}
