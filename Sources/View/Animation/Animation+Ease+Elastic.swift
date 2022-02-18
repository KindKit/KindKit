//
//  KindKitView
//

import Foundation
import KindKitCore

public extension Animation.Ease {

    struct ElasticIn : IAnimationEase {
        
        public init() {
        }

        public func perform(_ x: Float) -> Float {
            return sin(13 * .pi / 2 * x) * pow(2, 10 * (x - 1))
        }

    }

    struct ElasticOut : IAnimationEase {
        
        public init() {
        }

        public func perform(_ x: Float) -> Float {
            let f = sin(-13 * .pi / 2 * (x + 1))
            let g = pow(2, -10 * x)
            return f * g + 1
        }

    }

    struct ElasticInOut : IAnimationEase {
        
        public init() {
        }

        public func perform(_ x: Float) -> Float {
            if x < 1 / 2 {
                let f = sin(13 * .pi / 2 * (2 * x))
                return 1 / 2 * f * pow(2, 10 * (2 * x) - 1)
            } else {
                let h = (2 * x - 1) + 1
                let f = sin(-13 * .pi / 2 * h)
                let g = pow(2, -10 * (2 * x - 1))
                return 1 / 2 * (f * g + 2)
            }
        }

    }

}
