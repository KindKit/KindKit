//
//  KindKit
//

import Foundation

public extension Animation.Ease {

    struct SineIn : IAnimationEase {
        
        public init() {
        }

        public func perform(_ x: Float) -> Float {
            return (sin((x - 1) * .pi / 2) ) + 1
        }

    }

    struct SineOut : IAnimationEase {
        
        public init() {
        }

        public func perform(_ x: Float) -> Float {
            return sin(x * .pi / 2)
        }

    }

    struct SineInOut : IAnimationEase {
        
        public init() {
        }

        public func perform(_ x: Float) -> Float {
            return 1 / 2 * (1 - cos(x * .pi))
        }

    }

}
