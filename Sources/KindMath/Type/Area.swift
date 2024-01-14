//
//  KindKit
//

import Foundation
import KindCore

public struct Area : Hashable {
    
    public var value: Double
    
    public init(_ value: Double) {
        self.value = value
    }
    
}

public extension Area {
    
    static let zero = Area(0)
    
}

public extension Area {
    
    @inlinable
    static prefix func + (arg: Self) -> Self {
        return .init(+arg.value)
    }

    @inlinable
    static prefix func - (arg: Self) -> Self {
        return .init(-arg.value)
    }
    
}

public extension Area {

    @inlinable
    static func + (lhs: Self, rhs: Self) -> Self {
        return .init(lhs.value + rhs.value)
    }
    
}

public extension Area {

    @inlinable
    static func += (lhs: inout Self, rhs: Self) {
        lhs = lhs + rhs
    }
    
}

public extension Area {

    @inlinable
    static func - (lhs: Self, rhs: Self) -> Self {
        return .init(lhs.value - rhs.value)
    }
    
}

public extension Area {

    @inlinable
    static func -= (lhs: inout Self, rhs: Self) {
        lhs = lhs - rhs
    }
    
}

public extension Area {

    @inlinable
    static func * (lhs: Self, rhs: Self) -> Self {
        return .init(lhs.value * rhs.value)
    }
    
    @inlinable
    static func * (lhs: Self, rhs: Percent) -> Self {
        return .init(lhs.value * rhs.value)
    }
    
}

public extension Area {

    @inlinable
    static func *= (lhs: inout Self, rhs: Self) {
        lhs = lhs * rhs
    }
    
    @inlinable
    static func *= (lhs: inout Self, rhs: Percent) {
        lhs = lhs * rhs
    }
    
}

public extension Area {

    @inlinable
    static func / (lhs: Self, rhs: Self) -> Self {
        return .init(lhs.value / rhs.value)
    }
    
    @inlinable
    static func / (lhs: Self, rhs: Percent) -> Self {
        return .init(lhs.value / rhs.value)
    }
    
}

public extension Area {

    @inlinable
    static func /= (lhs: inout Self, rhs: Self) {
        lhs = lhs / rhs
    }
    
    @inlinable
    static func /= (lhs: inout Self, rhs: Percent) {
        lhs = lhs / rhs
    }
    
}

extension Area : Comparable {
    
    public static func < (lhs: Self, rhs: Self) -> Bool {
        return lhs.value < rhs.value
    }
    
}

extension Area : IMapable {
}

extension Area : INearEqutable {
    
    @inlinable
    public static func ~~ (lhs: Self, rhs: Self) -> Bool {
        return lhs.value ~~ rhs.value
    }
    
}

extension Area : ILerpable {
    
    @inlinable
    public func lerp(_ to: Self, progress: Percent) -> Self {
        return .init(self.value.lerp(to.value, progress: progress))
    }
    
}
