//
//  KindKit
//

import Foundation

public extension Ease {

    struct QuadraticIn : IEase {
        
        public init() {
        }

        public func perform(_ x: Double) -> Double {
            return x * x
        }

    }

    struct QuadraticOut : IEase {
        
        public init() {
        }

        public func perform(_ x: Double) -> Double {
            return -(x * (x - 2))
        }

    }

    struct QuadraticInOut : IEase {
        
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
