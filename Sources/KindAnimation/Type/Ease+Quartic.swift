//
//  KindKit
//

import Foundation

public extension Ease {

    struct QuarticIn : IEase {
        
        public init() {
        }

        public func perform(_ x: Double) -> Double {
            return x * x * x * x
        }

    }

    struct QuarticOut : IEase {
        
        public init() {
        }

        public func perform(_ x: Double) -> Double {
            let f = x - 1
            return f * f * f * (1 - x) + 1
        }

    }

    struct QuarticInOut : IEase {
        
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
