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
    
    static let degrees0 =  Angle(radians: 0)
    static let degrees45 = Angle(radians: .pi / 4)
    static let degrees90 = Angle(radians: .pi / 2)
    static let degrees135 = Angle.degrees90 + Angle.degrees45
    static let degrees180 = Angle(radians: .pi)
    static let degrees225 = Angle.degrees180 + Angle.degrees45
    static let degrees270 = Angle.degrees180 + Angle.degrees90
    static let degrees315 = Angle.degrees270 + Angle.degrees45
    static let degrees360 =  Angle(radians: .pi * 2)

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
    static func += (lhs: inout Self, rhs: Self) {
        lhs = lhs + rhs
    }
    
    @inlinable
    static func - (lhs: Self, rhs: Self) -> Self {
        return Angle(radians: lhs.radians - rhs.radians)
    }
    
    @inlinable
    static func -= (lhs: inout Self, rhs: Self) {
        lhs = lhs - rhs
    }
    
    @inlinable
    static func * (lhs: Self, rhs: Self) -> Self {
        return Angle(radians: lhs.radians * rhs.radians)
    }
    
    @inlinable
    static func * (lhs: Self, rhs: Percent) -> Self {
        return Angle(radians: lhs.radians * rhs.value)
    }
    
    @inlinable
    static func *= (lhs: inout Self, rhs: Self) {
        lhs = lhs * rhs
    }
    
    @inlinable
    static func *= (lhs: inout Self, rhs: Percent) {
        lhs = lhs * rhs
    }
    
    @inlinable
    static func / (lhs: Self, rhs: Self) -> Self {
        return Angle(radians: lhs.radians / rhs.radians)
    }
    
    @inlinable
    static func / (lhs: Self, rhs: Percent) -> Self {
        return Angle(radians: lhs.radians / rhs.value)
    }
    
    @inlinable
    static func /= (lhs: inout Self, rhs: Self) {
        lhs = lhs / rhs
    }
    
    @inlinable
    static func /= (lhs: inout Self, rhs: Percent) {
        lhs = lhs / rhs
    }
    
}

extension Angle : Comparable {
    
    public static func < (lhs: Self, rhs: Self) -> Bool {
        return lhs.radians < rhs.radians
    }
    
}

extension Angle : IMapable {
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
