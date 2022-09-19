//
//  KindKit
//

import Foundation

public extension Animation.Ease {

    struct Linear : IAnimationEase {
        
        public init() {
        }

        public func perform(_ x: Float) -> Float {
            return x
        }

    }

}
