//
//  KindKit
//

import Foundation

public extension Animation.Ease {

    struct SineIn : IAnimationEase {
        
        public init() {
        }

        public func perform(_ x: Double) -> Double {
            return (sin((x - 1) * .pi / 2) ) + 1
        }

    }

    struct SineOut : IAnimationEase {
        
        public init() {
        }

        public func perform(_ x: Double) -> Double {
            return sin(x * .pi / 2)
        }

    }

    struct SineInOut : IAnimationEase {
        
        public init() {
        }

        public func perform(_ x: Double) -> Double {
            return 1 / 2 * (1 - cos(x * .pi))
        }

    }

}

public extension IAnimationEase where Self == Animation.Ease.SineIn {
    
    @inlinable
    static func sineIn() -> Self {
        return .init()
    }
    
}

public extension IAnimationEase where Self == Animation.Ease.SineOut {
    
    @inlinable
    static func sineOut() -> Self {
        return .init()
    }
    
}

public extension IAnimationEase where Self == Animation.Ease.SineInOut {
    
    @inlinable
    static func sineInOut() -> Self {
        return .init()
    }
    
}
