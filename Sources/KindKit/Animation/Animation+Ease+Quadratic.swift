//
//  KindKit
//

import Foundation

public extension Animation.Ease {

    struct QuadraticIn : IAnimationEase {
        
        public init() {
        }

        public func perform(_ x: Double) -> Double {
            return x * x
        }

    }

    struct QuadraticOut : IAnimationEase {
        
        public init() {
        }

        public func perform(_ x: Double) -> Double {
            return -(x * (x - 2))
        }

    }

    struct QuadraticInOut : IAnimationEase {
        
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

}

public extension IAnimationEase where Self == Animation.Ease.QuadraticIn {
    
    @inlinable
    static func quadraticIn() -> Self {
        return .init()
    }
    
}

public extension IAnimationEase where Self == Animation.Ease.QuadraticOut {
    
    @inlinable
    static func quadraticOut() -> Self {
        return .init()
    }
    
}

public extension IAnimationEase where Self == Animation.Ease.QuadraticInOut {
    
    @inlinable
    static func quadraticInOut() -> Self {
        return .init()
    }
    
}
