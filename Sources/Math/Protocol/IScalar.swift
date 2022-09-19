//
//  KindKit
//

import Foundation
#if canImport(CoreGraphics)
import CoreGraphics
#endif

public protocol IScalar : ExpressibleByIntegerLiteral, ExpressibleByFloatLiteral, Comparable, INearEqutable {
    
    static var epsilon: Self { get }
    static var infinity: Self { get }
    static var pi: Self { get }
    static var leastNormalMagnitude: Self { get }
    static var greatestFiniteMagnitude: Self { get }
    
    var isInfinite: Bool { get }
    
    var double: Double { get }
    
    #if canImport(CoreGraphics)
    var cgFloat: CGFloat { get }
    #endif
    
    var roundUp: Self { get }
    var roundDown: Self { get }
    var roundNearest: Self { get }

    var abs: Self { get }
    var sqrt: Self { get }
    var sin: Self { get }
    var asin: Self { get }
    var cos: Self { get }
    var acos: Self { get }
    
    init< Value : BinaryInteger >(_ value: Value)
    
    init< Value : BinaryFloatingPoint >(_ value: Value)
    
    func clamp(_ lower: Self, _ upper: Self) -> Self
    func lerp(_ to: Self, progress: Self) -> Self
    
    func atan2(_ other: Self) -> Self
    
    static prefix func + (arg: Self) -> Self
    static prefix func - (arg: Self) -> Self
    
    static func + (lhs: Self, rhs: Self) -> Self
    static func += (lhs: inout Self, rhs: Self)
    static func - (lhs: Self, rhs: Self) -> Self
    static func -= (lhs: inout Self, rhs: Self)
    static func * (lhs: Self, rhs: Self) -> Self
    static func *= (lhs: inout Self, rhs: Self)
    static func / (lhs: Self, rhs: Self) -> Self
    static func /= (lhs: inout Self, rhs: Self)
    
    static func == (lhs: Self, rhs: Self) -> Bool
    static func != (lhs: Self, rhs: Self) -> Bool
    static func < (lhs: Self, rhs: Self) -> Bool
    static func <= (lhs: Self, rhs: Self) -> Bool
    static func > (lhs: Self, rhs: Self) -> Bool
    static func >= (lhs: Self, rhs: Self) -> Bool
    
}

public extension IScalar {
    
    @inlinable
    var degreesToRadians: Self {
        return self * .pi / 180
    }
    
    @inlinable
    var radiansToDegrees: Self {
        return self * 180 / .pi
    }
    
}

public extension IScalar {
    
    @inlinable
    func clamp(_ lower: Self, _ upper: Self) -> Self {
        if self < lower {
            return lower
        } else if self > upper {
            return upper
        }
        return self
    }
    
    @inlinable
    func lerp(_ to: Self, progress: Self) -> Self {
        if self ~~ to {
            return self
        }
        return ((1 - progress) * self) + (progress * to)
    }
    
    func lerp(_ to: Self, progress: Percent< Self >) -> Self where Self : Hashable {
        return self.lerp(to, progress: progress.value)
    }
    
}
