//
//  KindKitMath
//

import Foundation

public typealias DistanceFloat = Distance< Float >
public typealias DistanceDouble = Distance< Double >

public struct Distance< Value : IScalar & Hashable > : Hashable {
    
    public var squared: Value
    public var real: Value {
        return self.squared.sqrt
    }
    
    @inlinable
    public init(real: Value) {
        self.squared = real * real
    }
    
    @inlinable
    public init(squared: Value) {
        self.squared = squared
    }
    
}

public extension Distance {
    
    @inlinable
    static var zero: Self {
        return Distance(squared: 0)
    }
    
}

public extension Distance {
    
    @inlinable
    var abs: Self {
        return Distance(squared: self.squared.abs)
    }
    
}

public extension Distance {
    
    @inlinable
    static prefix func - (arg: Self) -> Self {
        return Distance(squared: -arg.squared)
    }
    
    @inlinable
    static func + (lhs: Self, rhs: Self) -> Self {
        return Distance(squared: lhs.squared + rhs.squared)
    }
    
    @inlinable
    static func += (lhs: inout Self, rhs: Self) {
        lhs = lhs + rhs
    }
    
    @inlinable
    static func - (lhs: Self, rhs: Self) -> Self {
        return Distance(squared: lhs.squared - rhs.squared)
    }
    
    @inlinable
    static func -= (lhs: inout Self, rhs: Self) {
        lhs = lhs - rhs
    }
    
    @inlinable
    static func * (lhs: Self, rhs: Self) -> Self {
        return Distance(squared: lhs.squared * rhs.squared)
    }
    
    @inlinable
    static func * (lhs: Self, rhs: Value) -> Self {
        return Distance(squared: lhs.squared * rhs)
    }
    
    @inlinable
    static func *= (lhs: inout Self, rhs: Self) {
        lhs = lhs * rhs
    }
    
    @inlinable
    static func *= (lhs: inout Self, rhs: Value) {
        lhs = lhs * rhs
    }
    
    @inlinable
    static func / (lhs: Self, rhs: Self) -> Self {
        return Distance(squared: lhs.squared / rhs.squared)
    }
    
    @inlinable
    static func / (lhs: Self, rhs: Value) -> Self {
        return Distance(squared: lhs.squared / rhs)
    }
    
    @inlinable
    static func /= (lhs: inout Self, rhs: Self) {
        lhs = lhs / rhs
    }
    
    @inlinable
    static func /= (lhs: inout Self, rhs: Value) {
        lhs = lhs / rhs
    }
    
}

extension Distance : INearEqutable {
    
    @inlinable
    public static func ~~ (lhs: Self, rhs: Self) -> Bool {
        return lhs.squared ~~ rhs.squared
    }
    
}

extension Distance : Comparable where Value : Comparable {
    
    public static func < (lhs: Self, rhs: Self) -> Bool {
        return lhs.squared < rhs.squared
    }
    
}
