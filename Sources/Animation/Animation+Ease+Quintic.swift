//
//  KindKit
//

import Foundation

public extension Animation.Ease {

    struct QuinticIn : IAnimationEase {
        
        public init() {
        }

        public func perform(_ x: Float) -> Float {
            return x * x * x * x * x
        }

    }

    struct QuinticOut : IAnimationEase {
        
        public init() {
        }

        public func perform(_ x: Float) -> Float {
            let f = (x - 1)
            return f * f * f * f * f + 1
        }

    }

    struct QuinticInOut : IAnimationEase {
        
        public init() {
        }

        public func perform(_ x: Float) -> Float {
            if x < 1 / 2 {
                return 16 * x * x * x * x * x
            } else {
                let f = ((2 * x) - 2)
                return  1 / 2 * f * f * f * f * f + 1
            }
        }

    }

}
