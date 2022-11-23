//
//  KindKit
//

import Foundation

public struct Angle : Hashable {
    
    public var degrees: Double {
        return self.radians.radiansToDegrees
    }
    public var radians: Double
    
    public init(radians: Double) {
        self.radians = radians
    }
    
    public init(degrees: Double) {
        self.radians = degrees.degreesToRadians
    }
    
}

public extension Angle {
    
    @inlinable
    static var degrees0: Self {
        return Angle(radians: 0)
    }
    
    @inlinable
    static var degrees90: Self {
        return Angle(radians: .pi / 2)
    }
    
    @inlinable
    static var degrees180: Self {
        return Angle(radians: .pi)
    }
    
    @inlinable
    static var degrees270: Self {
        return Angle(radians: 3 * .pi / 2)
    }
    
    @inlinable
    static var degrees360: Self {
        return Angle(radians: .pi * 2)
    }

}

public extension Angle {
    
    @inlinable
    var normalized: Self {
        var r = self
        let l = Double.pi * 2
        while r.radians <= -l {
            r.radians += l
        }
        while r.radians >= l {
            r.radians -= l
        }
        return r
    }
    
}

public extension Angle {
    
    @inlinable
    static prefix func - (arg: Self) -> Self {
        return Angle(radians: -arg.radians)
    }
    
    @inlinable
    static func + (lhs: Self, rhs: Self) -> Self {
        return Angle(radians: lhs.radians + rhs.radians)
    }
    
    @inlinable
    static func + (lhs: Self, rhs: Double) -> Self {
        return Angle(radians: lhs.radians + rhs)
    }
    
    @inlinable
    static func += (lhs: inout Self, rhs: Self) {
        lhs = lhs + rhs
    }
    
    @inlinable
    static func += (lhs: inout Self, rhs: Double) {
        lhs = lhs + rhs
    }
    
    @inlinable
    static func - (lhs: Self, rhs: Self) -> Self {
        return Angle(radians: lhs.radians - rhs.radians)
    }
    
    @inlinable
    static func - (lhs: Self, rhs: Double) -> Self {
        return Angle(radians: lhs.radians - rhs)
    }
    
    @inlinable
    static func -= (lhs: inout Self, rhs: Self) {
        lhs = lhs - rhs
    }
    
    @inlinable
    static func -= (lhs: inout Self, rhs: Double) {
        lhs = lhs - rhs
    }
    
    @inlinable
    static func * (lhs: Self, rhs: Self) -> Self {
        return Angle(radians: lhs.radians * rhs.radians)
    }
    
    @inlinable
    static func * (lhs: Self, rhs: Double) -> Self {
        return Angle(radians: lhs.radians * rhs)
    }
    
    @inlinable
    static func *= (lhs: inout Self, rhs: Self) {
        lhs = lhs * rhs
    }
    
    @inlinable
    static func *= (lhs: inout Self, rhs: Double) {
        lhs = lhs * rhs
    }
    
    @inlinable
    static func / (lhs: Self, rhs: Self) -> Self {
        return Angle(radians: lhs.radians / rhs.radians)
    }
    
    @inlinable
    static func / (lhs: Self, rhs: Double) -> Self {
        return Angle(radians: lhs.radians / rhs)
    }
    
    @inlinable
    static func /= (lhs: inout Self, rhs: Self) {
        lhs = lhs / rhs
    }
    
    @inlinable
    static func /= (lhs: inout Self, rhs: Double) {
        lhs = lhs / rhs
    }
    
}

extension Angle : Comparable {
    
    public static func < (lhs: Self, rhs: Self) -> Bool {
        return lhs.radians < rhs.radians
    }
    
}

extension Angle : INearEqutable {
    
    @inlinable
    public static func ~~ (lhs: Self, rhs: Self) -> Bool {
        return lhs.radians ~~ rhs.radians
    }
    
}

extension Angle : ILerpable {
    
    @inlinable
    public func lerp(_ to: Self, progress: Percent) -> Self {
        let radians = self.radians.lerp(to.radians, progress: progress)
        return Angle(radians: radians)
    }
    
}
