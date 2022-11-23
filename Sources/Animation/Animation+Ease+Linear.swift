//
//  KindKit
//

import Foundation

public extension Animation.Ease {

    struct Linear : IAnimationEase {
        
        public init() {
        }

        public func perform(_ x: Double) -> Double {
            return x
        }

    }

}

public extension IAnimationEase where Self == Animation.Ease.Linear {
    
    @inlinable
    static func linear() -> Self {
        return .init()
    }
    
}
