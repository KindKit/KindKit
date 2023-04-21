//
//  KindKit
//

import Foundation

public struct Inset : Hashable {
    
    public var top: Double
    public var left: Double
    public var right: Double
    public var bottom: Double
    
    public init(top: Double, left: Double, right: Double, bottom: Double) {
        self.top = top
        self.left = left
        self.right = right
        self.bottom = bottom
    }
    
    public init(horizontal: Double, vertical: Double) {
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
    var horizontal: Double {
        return self.left + self.right
    }
    
    @inlinable
    var vertical: Double {
        return self.top + self.bottom
    }
    
}

public extension Inset {
    
    @inlinable
    func trim(
        top: Bool = false,
        left: Bool = false,
        right: Bool = false,
        bottom: Bool = false
    ) -> Self {
        return .init(
            top: top == true ? 0 : self.top,
            left: left == true ? 0 : self.left,
            right: right == true ? 0 : self.right,
            bottom: bottom == true ? 0 : self.bottom
        )
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

extension Inset : Comparable {
    
    public static func < (lhs: Self, rhs: Self) -> Bool {
        return lhs.top < rhs.top && lhs.left < rhs.left && lhs.right < rhs.right && lhs.bottom < rhs.bottom
    }
    
}

extension Inset : INearEqutable {
    
    @inlinable
    public static func ~~ (lhs: Self, rhs: Self) -> Bool {
        return lhs.top ~~ rhs.top && lhs.left ~~ rhs.left && lhs.right ~~ rhs.right && lhs.bottom ~~ rhs.bottom
    }
    
}

extension Inset : ILerpable {
    
    @inlinable
    public func lerp(_ to: Self, progress: Percent) -> Self {
        let top = self.top.lerp(to.top, progress: progress)
        let left = self.left.lerp(to.left, progress: progress)
        let right = self.right.lerp(to.right, progress: progress)
        let bottom = self.bottom.lerp(to.bottom, progress: progress)
        return .init(top: top, left: left, right: right, bottom: bottom)
    }
    
}
