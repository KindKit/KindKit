//
//  KindKit
//

import Foundation

public extension Animation.Ease {

    struct CircularIn : IAnimationEase {
        
        public init() {
        }

        public func perform(_ x: Double) -> Double {
            return 1 - sqrt(1 - (x * x))
        }

    }

    struct CircularOut : IAnimationEase {
        
        public init() {
        }

        public func perform(_ x: Double) -> Double {
            return sqrt((2 - x) * x)
        }

    }

    struct CircularInOut : IAnimationEase {
        
        public init() {
        }

        public func perform(_ x: Double) -> Double {
            if x < 1 / 2 {
                let h = 1 - sqrt(1 - 4 * (x * x))
                return 1 / 2 * h
            } else {
                let f = -((2 * x) - 3) * ((2 * x) - 1)
                let g = sqrt( f )
                return 1 / 2 * ( g + 1 )
            }
        }

    }

}

public extension IAnimationEase where Self == Animation.Ease.CircularIn {
    
    @inlinable
    static func circularIn() -> Self {
        return .init()
    }
    
}

public extension IAnimationEase where Self == Animation.Ease.CircularOut {
    
    @inlinable
    static func circularOut() -> Self {
        return .init()
    }
    
}

public extension IAnimationEase where Self == Animation.Ease.CircularInOut {
    
    @inlinable
    static func circularInOut() -> Self {
        return .init()
    }
    
}
