//
//  KindKitView
//

import Foundation
import KindKitCore

public extension Animation.Ease {

    struct QuadraticIn : IAnimationEase {
        
        public init() {
        }

        public func perform(_ x: Float) -> Float {
            return x * x
        }

    }

    struct QuadraticOut : IAnimationEase {
        
        public init() {
        }

        public func perform(_ x: Float) -> Float {
            return -(x * (x - 2))
        }

    }

    struct QuadraticInOut : IAnimationEase {
        
        public init() {
        }

        public func perform(_ x: Float) -> Float {
            if x < 1 / 2 {
                return 2 * x * x
            } else {
                return (-2 * x * x) + (4 * x) - 1
            }
        }

    }

}
