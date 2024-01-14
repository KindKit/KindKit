//
//  KindKit
//

import Foundation

public extension Ease {

    struct QuinticIn : IEase {
        
        public init() {
        }

        public func perform(_ x: Double) -> Double {
            return x * x * x * x * x
        }

    }

    struct QuinticOut : IEase {
        
        public init() {
        }

        public func perform(_ x: Double) -> Double {
            let f = (x - 1)
            return f * f * f * f * f + 1
        }

    }

    struct QuinticInOut : IEase {
        
        public init() {
        }

        public func perform(_ x: Double) -> Double {
            if x < 1 / 2 {
                return 16 * x * x * x * x * x
            } else {
                let f = ((2 * x) - 2)
                return  1 / 2 * f * f * f * f * f + 1
            }
        }

    }

}
