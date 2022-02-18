//
//  KindKitView
//

import Foundation
import KindKitCore

public extension Animation.Ease {

    struct QuarticIn : IAnimationEase {
        
        public init() {
        }

        public func perform(_ x: Float) -> Float {
            return x * x * x * x
        }

    }

    struct QuarticOut : IAnimationEase {
        
        public init() {
        }

        public func perform(_ x: Float) -> Float {
            let f = x - 1
            return f * f * f * (1 - x) + 1
        }

    }

    struct QuarticInOut : IAnimationEase {
        
        public init() {
        }

        public func perform(_ x: Float) -> Float {
            if x < 1/2 {
                return 8 * x * x * x * x
            } else {
                let f = (x - 1)
                return -8 * f * f * f * f + 1
            }
        }

    }

}
