//
//  KindKitMath
//

import Foundation

public extension BinaryFloatingPoint {
    
    @inlinable
    var degreesToRadians: Self {
        return self * .pi / 180
    }
    
    @inlinable
    var radiansToDegrees: Self {
        return self * 180 / .pi
    }
    
    @inlinable
    func lerp(_ to: Self, progress: Self) -> Self {
        if abs(self - to) > Self.leastNonzeroMagnitude {
            return ((1 - progress) * self) + (progress * to)
        }
        return self
    }

}
