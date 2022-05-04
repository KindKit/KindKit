//
//  KindKitMath
//

import Foundation

public typealias AngleFloat = Angle< Float >
public typealias AngleDouble = Angle< Double >

public struct Angle< ValueType: IScalar & Hashable > : Hashable {
    
    public var degrees: ValueType {
        return self.radians.radiansToDegrees
    }
    public var radians: ValueType
    
    @inlinable
    public init(radians: ValueType) {
        self.radians = radians
    }
    
    @inlinable
    public init(degrees: ValueType) {
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
        let l = ValueType.pi * 2
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
    static func + (lhs: Self, rhs: ValueType) -> Self {
        return Angle(radians: lhs.radians + rhs)
    }
    
    @inlinable
    static func += (lhs: inout Self, rhs: Self) {
        lhs = lhs + rhs
    }
    
    @inlinable
    static func += (lhs: inout Self, rhs: ValueType) {
        lhs = lhs + rhs
    }
    
    @inlinable
    static func - (lhs: Self, rhs: Self) -> Self {
        return Angle(radians: lhs.radians - rhs.radians)
    }
    
    @inlinable
    static func - (lhs: Self, rhs: ValueType) -> Self {
        return Angle(radians: lhs.radians - rhs)
    }
    
    @inlinable
    static func -= (lhs: inout Self, rhs: Self) {
        lhs = lhs - rhs
    }
    
    @inlinable
    static func -= (lhs: inout Self, rhs: ValueType) {
        lhs = lhs - rhs
    }
    
    @inlinable
    static func * (lhs: Self, rhs: Self) -> Self {
        return Angle(radians: lhs.radians * rhs.radians)
    }
    
    @inlinable
    static func * (lhs: Self, rhs: ValueType) -> Self {
        return Angle(radians: lhs.radians * rhs)
    }
    
    @inlinable
    static func *= (lhs: inout Self, rhs: Self) {
        lhs = lhs * rhs
    }
    
    @inlinable
    static func *= (lhs: inout Self, rhs: ValueType) {
        lhs = lhs * rhs
    }
    
    @inlinable
    static func / (lhs: Self, rhs: Self) -> Self {
        return Angle(radians: lhs.radians / rhs.radians)
    }
    
    @inlinable
    static func / (lhs: Self, rhs: ValueType) -> Self {
        return Angle(radians: lhs.radians / rhs)
    }
    
    @inlinable
    static func /= (lhs: inout Self, rhs: Self) {
        lhs = lhs / rhs
    }
    
    @inlinable
    static func /= (lhs: inout Self, rhs: ValueType) {
        lhs = lhs / rhs
    }
    
}

extension Angle : INearEqutable {
    
    @inlinable
    public static func ~~ (lhs: Self, rhs: Self) -> Bool {
        return lhs.radians ~~ rhs.radians
    }
    
}

extension Angle : Comparable where ValueType: Comparable {
    
    public static func < (lhs: Self, rhs: Self) -> Bool {
        return lhs.radians < rhs.radians
    }
    
}
