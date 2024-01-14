//
//  KindKit
//

import Foundation

public extension Ease {

    struct Linear : IEase {
        
        public init() {
        }

        public func perform(_ x: Double) -> Double {
            return x
        }

    }

}
