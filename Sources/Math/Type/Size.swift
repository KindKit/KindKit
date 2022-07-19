//
//  KindKitMath
//

import Foundation

public typealias SizeFloat = Size< Float >
public typealias SizeDouble = Size< Double >

public struct Size< Value : IScalar & Hashable > : Hashable {
    
    public var width: Value
    public var height: Value
    
    @inlinable
    public init(
        width: Value,
        height: Value
    ) {
        self.width = width
        self.height = height
    }
    
}

public extension Size {
    
    @inlinable
    static var infinity: Self {
        return Size(width: .infinity, height: .infinity)
    }
    
    @inlinable
    static var zero: Self {
        return Size(width: 0, height: 0)
    }
    
}

public extension Size {
    
    @inlinable
    var isInfinite: Bool {
        return self.width.isInfinite == true && self.height.isInfinite == true
    }
    
    @inlinable
    var isZero: Bool {
        return self ~~ .zero
    }
    
    @inlinable
    var wrap: Self {
        return Size(width: self.height, height: self.height)
    }
    
    @inlinable
    var aspectRatio: Value {
        return self.width / self.height
    }
    
}

public extension Size {
    
    @inlinable
    func max(_ arg: Self) -> Self {
        return Size(width: Swift.max(self.width, arg.width), height: Swift.max(self.height, arg.height))
    }
    
    @inlinable
    func min(_ arg: Self) -> Self {
        return Size(width: Swift.min(self.width, arg.width), height: Swift.min(self.height, arg.height))
    }
    
    @inlinable
    func inset(horizontal: Value, vertical: Value) -> Self {
        let width: Value
        if self.width.isInfinite == false {
            width = self.width - horizontal
        } else {
            width = self.width
        }
        let height: Value
        if self.height.isInfinite == false {
            height = self.height - vertical
        } else {
            height = self.height
        }
        return Size(width: width, height: height)
    }
    
    @inlinable
    func inset(_ value: Inset< Value >) -> Self {
        return self.inset(horizontal: value.horizontal, vertical: value.vertical)
    }
    
    @inlinable
    func aspectFit(_ size: Self) -> Self {
        let fw = size.width / self.width
        let fh = size.height / self.height
        let sc = (fw < fh) ? fw : fh
        return Size(width: self.width * sc, height: self.height * sc)
    }
    
    @inlinable
    func aspectFill(_ size: Self) -> Self {
        let fw = size.width / self.width
        let fh = size.height / self.height
        let sc = (fw > fh) ? fw : fh
        return Size(width: self.width * sc, height: self.height * sc)
    }
    
    @inlinable
    func lerp(_ to: Self, progress: Value) -> Self {
        let width = self.width.lerp(to.width, progress: progress)
        let height = self.height.lerp(to.height, progress: progress)
        return Size(width: width, height: height)
    }
    
    @inlinable
    func lerp(_ to: Self, progress: Percent< Value >) -> Self {
        return self.lerp(to, progress: progress.value)
    }
    
}

public extension Size {
    
    @inlinable
    static prefix func - (arg: Self) -> Self {
        return Size(width: -arg.width, height: -arg.height)
    }
    
    @inlinable
    static func + (lhs: Self, rhs: Self) -> Self {
        return Size(width: lhs.width + rhs.width, height: lhs.height + rhs.height)
    }
    
    @inlinable
    static func + (lhs: Self, rhs: Value) -> Self {
        return Size(width: lhs.width + rhs, height: lhs.height + rhs)
    }
    
    @inlinable
    static func += (lhs: inout Self, rhs: Self) {
        lhs = lhs + rhs
    }
    
    @inlinable
    static func += (lhs: inout Self, rhs: Value) {
        lhs = lhs + rhs
    }
    
    @inlinable
    static func - (lhs: Self, rhs: Self) -> Self {
        return Size(width: lhs.width - rhs.width, height: lhs.height - rhs.height)
    }
    
    @inlinable
    static func - (lhs: Self, rhs: Value) -> Self {
        return Size(width: lhs.width - rhs, height: lhs.height - rhs)
    }
    
    @inlinable
    static func -= (lhs: inout Self, rhs: Self) {
        lhs = lhs - rhs
    }
    
    @inlinable
    static func -= (lhs: inout Self, rhs: Value) {
        lhs = lhs - rhs
    }
    
    @inlinable
    static func * (lhs: Self, rhs: Self) -> Self {
        return Size(width: lhs.width * rhs.width, height: lhs.height * rhs.height)
    }
    
    @inlinable
    static func * (lhs: Self, rhs: Value) -> Self {
        return Size(width: lhs.width * rhs, height: lhs.height * rhs)
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
        return Size(width: lhs.width / rhs.width, height: lhs.height / rhs.height)
    }
    
    @inlinable
    static func / (lhs: Self, rhs: Value) -> Self {
        return Size(width: lhs.width / rhs, height: lhs.height / rhs)
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

extension Size : INearEqutable {
    
    @inlinable
    public static func ~~ (lhs: Self, rhs: Self) -> Bool {
        return lhs.width ~~ rhs.width && lhs.height ~~ rhs.height
    }
    
}

extension Size : Comparable where Value : Comparable {
    
    public static func < (lhs: Self, rhs: Self) -> Bool {
        return lhs.width < rhs.width && lhs.height < rhs.height
    }
    
}
