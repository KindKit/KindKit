//
//  KindKitMath
//

import Foundation

public typealias InsetFloat = Inset< Float >
public typealias InsetDouble = Inset< Double >

public struct Inset< ValueType: BinaryFloatingPoint > : Hashable {
    
    public var top: ValueType
    public var left: ValueType
    public var right: ValueType
    public var bottom: ValueType
    
    @inlinable
    public init(top: ValueType, left: ValueType, right: ValueType, bottom: ValueType) {
        self.top = top
        self.left = left
        self.right = right
        self.bottom = bottom
    }
    
    @inlinable
    public init(horizontal: ValueType, vertical: ValueType) {
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
        return self.top.isZero == true && self.left.isZero == true && self.right.isZero == true && self.bottom.isZero == true
    }
    
    @inlinable
    var horizontal: ValueType {
        return self.left + self.right
    }
    
    @inlinable
    var vertical: ValueType {
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

extension Inset : Comparable where ValueType: Comparable {
    
    public static func < (lhs: Self, rhs: Self) -> Bool {
        return lhs.top < rhs.top && lhs.left < rhs.left && lhs.right < rhs.right && lhs.bottom < rhs.bottom
    }
    
}
