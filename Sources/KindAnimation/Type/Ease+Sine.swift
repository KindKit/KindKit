//
//  KindKit
//

import Foundation

public extension Ease {

    struct SineIn : IEase {
        
        public init() {
        }

        public func perform(_ x: Double) -> Double {
            return (sin((x - 1) * .pi / 2) ) + 1
        }

    }

    struct SineOut : IEase {
        
        public init() {
        }

        public func perform(_ x: Double) -> Double {
            return sin(x * .pi / 2)
        }

    }

    struct SineInOut : IEase {
        
        public init() {
        }

        public func perform(_ x: Double) -> Double {
            return 1 / 2 * (1 - cos(x * .pi))
        }

    }

}
