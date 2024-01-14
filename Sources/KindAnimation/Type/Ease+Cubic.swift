//
//  KindKit
//

import Foundation

public extension Ease {

    struct CubicIn : IEase {
        
        public init() {
        }

        public func perform(_ x: Double) -> Double {
            return x * x * x
        }

    }

    struct CubicOut : IEase {
        
        public init() {
        }

        public func perform(_ x: Double) -> Double {
            let p = x - 1
            return  p * p * p + 1
        }

    }

    struct CubicInOut : IEase {
        
        public init() {
        }

        public func perform(_ x: Double) -> Double {
            if x < 1/2 {
                return 4 * x * x * x
            } else {
                let f = ((2 * x) - 2)
                return 1/2 * f * f * f + 1
            }
        }

    }

}
