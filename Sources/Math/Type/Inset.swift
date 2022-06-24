//
//  KindKitMath
//

import Foundation

public typealias InsetFloat = Inset< Float >
public typealias InsetDouble = Inset< Double >

public struct Inset< Value: IScalar & Hashable > : Hashable {
    
    public var top: Value
    public var left: Value
    public var right: Value
    public var bottom: Value
    
    @inlinable
    public init(top: Value, left: Value, right: Value, bottom: Value) {
        self.top = top
        self.left = left
        self.right = right
        self.bottom = bottom
    }
    
    @inlinable
    public init(horizontal: Value, vertical: Value) {
        self.top = vertical
        self.left = horizontal
        self.right = horizontal
        self.bottom = vertical
    }
    
}

public extension Inset {
    
    @inlinable
    static var zero: Self {
        return Inset(horizontal: 0, vertical: 0)
    }
    
}

public extension Inset {
    
    @inlinable
    var isZero: Bool {
        return self ~~ .zero
    }
    
    @inlinable
    var horizontal: Value {
        return self.left + self.right
    }
    
    @inlinable
    var vertical: Value {
        return self.top + self.bottom
    }
    
}

public extension Inset {
    
    @inlinable
    static prefix func - (arg: Self) -> Self {
        return Inset(top: -arg.top, left: -arg.left, right: -arg.right, bottom: -arg.bottom)
    }
    
    @inlinable
    static func + (lhs: Self, rhs: Self) -> Self {
        return Inset(top: lhs.top + rhs.top, left: lhs.left + rhs.left, right: lhs.right + rhs.right, bottom: lhs.bottom + rhs.bottom)
    }
    
    @inlinable
    static func += (lhs: inout Self, rhs: Self) {
        lhs = lhs + rhs
    }
    
    @inlinable
    static func - (lhs: Self, rhs: Self) -> Self {
        return Inset(top: lhs.top - rhs.top, left: lhs.left - rhs.left, right: lhs.right - rhs.right, bottom: lhs.bottom - rhs.bottom)
    }
    
    @inlinable
    static func -= (lhs: inout Self, rhs: Self) {
        lhs = lhs - rhs
    }
    
    @inlinable
    static func * (lhs: Self, rhs: Self) -> Self {
        return Inset(top: lhs.top * rhs.top, left: lhs.left * rhs.left, right: lhs.right * rhs.right, bottom: lhs.bottom * rhs.bottom)
    }
    
    @inlinable
    static func *= (lhs: inout Self, rhs: Self) {
        lhs = lhs * rhs
    }
    
    @inlinable
    static func / (lhs: Self, rhs: Self) -> Self {
        return Inset(top: lhs.top / rhs.top, left: lhs.left / rhs.left, right: lhs.right / rhs.right, bottom: lhs.bottom / rhs.bottom)
    }
    
    @inlinable
    static func /= (lhs: inout Self, rhs: Self) {
        lhs = lhs / rhs
    }
    
}

extension Inset : INearEqutable {
    
    @inlinable
    public static func ~~ (lhs: Self, rhs: Self) -> Bool {
        return lhs.top ~~ rhs.top && lhs.left ~~ rhs.left && lhs.right ~~ rhs.right && lhs.bottom ~~ rhs.bottom
    }
    
}

extension Inset : Comparable where Value: Comparable {
    
    public static func < (lhs: Self, rhs: Self) -> Bool {
        return lhs.top < rhs.top && lhs.left < rhs.left && lhs.right < rhs.right && lhs.bottom < rhs.bottom
    }
    
}
