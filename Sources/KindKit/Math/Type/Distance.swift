//
//  KindKit
//

import Foundation

public struct Distance : Hashable {
    
    public var squared: Double
    public var real: Double {
        return self.squared.sqrt
    }
    
    public init(real: Double) {
        self.squared = real * real
    }
    
    public init(squared: Double) {
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
    static func * (lhs: Self, rhs: Double) -> Self {
        return Distance(squared: lhs.squared * rhs)
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
        return Distance(squared: lhs.squared / rhs.squared)
    }
    
    @inlinable
    static func / (lhs: Self, rhs: Double) -> Self {
        return Distance(squared: lhs.squared / rhs)
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

extension Distance : INearEqutable {
    
    @inlinable
    public static func ~~ (lhs: Self, rhs: Self) -> Bool {
        return lhs.squared ~~ rhs.squared
    }
    
}

extension Distance : Comparable {
    
    public static func < (lhs: Self, rhs: Self) -> Bool {
        return lhs.squared < rhs.squared
    }
    
}
