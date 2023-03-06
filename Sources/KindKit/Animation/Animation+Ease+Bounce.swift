//
//  KindKit
//

import Foundation

public extension Animation.Ease {
    
    struct BounceIn : IAnimationEase {

        private let _easeOut: BounceOut

        public init() {
            self._easeOut = BounceOut()
        }

        public func perform(_ x: Double) -> Double {
            return 1 - self._easeOut.perform(1 - x)
        }

    }

    struct BounceOut : IAnimationEase {
        
        public init() {
        }

        public func perform(_ x: Double) -> Double {
            if x < 4 / 11 {
                return (121 * x * x) / 16
            } else if x < 8 / 11 {
                let f = (363 / 40) * x * x
                let g = (99 / 10) * x
                return f - g + (17 / 5)
            } else if x < 9 / 10 {
                let f = (4356 / 361) * x * x
                let g = (35442 / 1805) * x
                return  f - g + (16061 / 1805)
            } else {
                let f = (54 / 5) * x * x
                return f - ((513 / 25) * x) + 268 / 25
            }
        }

    }

    struct BounceInOut : IAnimationEase {

        private let _easeIn: BounceIn
        private let _easeOut: BounceOut

        public init() {
            self._easeIn = BounceIn()
            self._easeOut = BounceOut()
        }

        public func perform(_ x: Double) -> Double {
            if x < 1 / 2 {
                return 1 / 2 * self._easeIn.perform(x * 2)
            } else {
                let f = self._easeOut.perform(x * 2 - 1) + 1
                return 1 / 2 * f
            }
        }

    }

}

public extension IAnimationEase where Self == Animation.Ease.BounceIn {
    
    @inlinable
    static func bounceIn() -> Self {
        return .init()
    }
    
}

public extension IAnimationEase where Self == Animation.Ease.BounceOut {
    
    @inlinable
    static func bounceOut() -> Self {
        return .init()
    }
    
}

public extension IAnimationEase where Self == Animation.Ease.BounceInOut {
    
    @inlinable
    static func bounceInOut() -> Self {
        return .init()
    }
    
}
