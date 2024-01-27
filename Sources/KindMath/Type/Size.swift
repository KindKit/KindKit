//
//  KindKit
//

import Foundation

public struct Size : Hashable {
    
    public var width: Double
    public var height: Double
    
    public init(
        width: Double,
        height: Double
    ) {
        self.width = width
        self.height = height
    }
    
    public init(
        _ point: Point
    ) {
        self.width = point.x
        self.height = point.y
    }
    
}

public extension Size {
    
    @inlinable
    static var infinity: Self {
        return .init(width: .infinity, height: .infinity)
    }
    
    @inlinable
    static var zero: Self {
        return .init(width: 0, height: 0)
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
    var normalized: Self {
        return Size(
            width: self.width.normalized(.zero),
            height: self.height.normalized(.zero)
        )
    }
    
    @inlinable
    var integral: Self {
        let n = self.normalized
        return .init(
            width: n.width.roundUp,
            height: n.height.roundUp
        )
    }
    
    @inlinable
    var wrap: Self {
        return .init(
            width: self.height,
            height: self.height
        )
    }
    
    @inlinable
    var area: Area {
        return .init(self.width * self.height)
    }
    
    @inlinable
    var aspectRatio: Double {
        return self.width / self.height
    }
    
}

public extension Size {
    
    @inlinable
    func normalized(width value: () -> Double) -> Self {
        return .init(
            width: self.width.normalized(value),
            height: self.height
        )
    }
    
    @inlinable
    func normalized(width value: @autoclosure () -> Double) -> Self {
        return .init(
            width: self.width.normalized(value),
            height: self.height
        )
    }
    
    @inlinable
    func normalized(height value: () -> Double) -> Self {
        return .init(
            width: self.width,
            height: self.height.normalized(value)
        )
    }
    
    @inlinable
    func normalized(height value: @autoclosure () -> Double) -> Self {
        return .init(
            width: self.width,
            height: self.height.normalized(value)
        )
    }
    
    @inlinable
    func normalized(_ value: Self) -> Self {
        return .init(
            width: self.width.normalized(value.width),
            height: self.height.normalized(value.height)
        )
    }
    
    @inlinable
    func normalized(_ block: (Self) -> Self) -> Self {
        if self.width.isInfinite == true || self.height.isInfinite == true {
            return block(self)
        }
        return self
    }
    
    @inlinable
    func max(_ arg: Self) -> Self {
        return .init(
            width: Swift.max(self.width, arg.width),
            height: Swift.max(self.height, arg.height)
        )
    }
    
    @inlinable
    func min(_ arg: Self) -> Self {
        return .init(
            width: Swift.min(self.width, arg.width),
            height: Swift.min(self.height, arg.height)
        )
    }
    
    @inlinable
    func inset(horizontal: Double, vertical: Double) -> Self {
        return .init(
            width: self.width.updating({ $0 - horizontal }),
            height: self.height.updating({ $0 - vertical })
        )
    }
    
    @inlinable
    func inset(all: Double) -> Self {
        return self.inset(
            horizontal: all,
            vertical: all
        )
    }
    
    @inlinable
    func inset(_ value: Inset) -> Self {
        return self.inset(
            horizontal: value.horizontal,
            vertical: value.vertical
        )
    }
    
    @inlinable
    func aspectFit(_ size: Self) -> Self {
        let fw = size.width / self.width
        let fh = size.height / self.height
        let sc = (fw < fh) ? fw : fh
        return .init(
            width: self.width * sc,
            height: self.height * sc
        )
    }
    
    @inlinable
    func aspectFill(_ size: Self) -> Self {
        let fw = size.width / self.width
        let fh = size.height / self.height
        let sc = (fw > fh) ? fw : fh
        return .init(
            width: self.width * sc,
            height: self.height * sc
        )
    }
    
}

public extension Size {
    
    @inlinable
    static prefix func + (arg: Self) -> Self {
        return .init(width: +arg.width, height: +arg.height)
    }
    
    @inlinable
    static prefix func - (arg: Self) -> Self {
        return .init(width: -arg.width, height: -arg.height)
    }
    
}

public extension Size {
    
    @inlinable
    static func + (lhs: Self, rhs: Self) -> Self {
        return .init(width: lhs.width + rhs.width, height: lhs.height + rhs.height)
    }
    
    @inlinable
    static func + < Value : BinaryInteger >(lhs: Self, rhs: Value) -> Self {
        return .init(width: lhs.width + Double(rhs), height: lhs.height + Double(rhs))
    }
    
    @inlinable
    static func + < Value : BinaryInteger >(lhs: Value, rhs: Self) -> Self {
        return .init(width: Double(lhs) + rhs.width, height: Double(lhs) + rhs.height)
    }
    
    @inlinable
    static func + < Value : BinaryFloatingPoint >(lhs: Self, rhs: Value) -> Self {
        return .init(width: lhs.width + Double(rhs), height: lhs.height + Double(rhs))
    }
    
    @inlinable
    static func + < Value : BinaryFloatingPoint >(lhs: Value, rhs: Self) -> Self {
        return .init(width: Double(lhs) + rhs.width, height: Double(lhs) + rhs.height)
    }
    
    @inlinable
    static func + (lhs: Self, rhs: Distance) -> Self {
        return .init(width: lhs.width + rhs.value, height: lhs.height + rhs.value)
    }
    
    @inlinable
    static func + (lhs: Self, rhs: Percent) -> Self {
        return .init(width: lhs.width + rhs.value, height: lhs.height + rhs.value)
    }
    
}

public extension Size {
    
    @inlinable
    static func += (lhs: inout Self, rhs: Self) {
        lhs = lhs + rhs
    }
    
    @inlinable
    static func += (lhs: inout Self, rhs: Distance) {
        lhs = lhs + rhs
    }
    
    @inlinable
    static func += (lhs: inout Self, rhs: Percent) {
        lhs = lhs + rhs
    }
    
}

public extension Size {
    
    @inlinable
    static func - (lhs: Self, rhs: Self) -> Self {
        return .init(width: lhs.width - rhs.width, height: lhs.height - rhs.height)
    }
    
    @inlinable
    static func - < Value : BinaryInteger >(lhs: Self, rhs: Value) -> Self {
        return .init(width: lhs.width - Double(rhs), height: lhs.height - Double(rhs))
    }
    
    @inlinable
    static func - < Value : BinaryInteger >(lhs: Value, rhs: Self) -> Self {
        return .init(width: Double(lhs) - rhs.width, height: Double(lhs) - rhs.height)
    }
    
    @inlinable
    static func - < Value : BinaryFloatingPoint >(lhs: Self, rhs: Value) -> Self {
        return .init(width: lhs.width - Double(rhs), height: lhs.height - Double(rhs))
    }
    
    @inlinable
    static func - < Value : BinaryFloatingPoint >(lhs: Value, rhs: Self) -> Self {
        return .init(width: Double(lhs) - rhs.width, height: Double(lhs) - rhs.height)
    }
    
    @inlinable
    static func - (lhs: Self, rhs: Distance) -> Self {
        return .init(width: lhs.width - rhs.value, height: lhs.height - rhs.value)
    }
    
    @inlinable
    static func - (lhs: Self, rhs: Percent) -> Self {
        return .init(width: lhs.width - rhs.value, height: lhs.height - rhs.value)
    }
    
}

public extension Size {
    
    @inlinable
    static func -= (lhs: inout Self, rhs: Self) {
        lhs = lhs - rhs
    }
    
    @inlinable
    static func -= (lhs: inout Self, rhs: Distance) {
        lhs = lhs - rhs
    }
    
    @inlinable
    static func -= (lhs: inout Self, rhs: Percent) {
        lhs = lhs - rhs
    }
    
}

public extension Size {
    
    @inlinable
    static func * (lhs: Self, rhs: Self) -> Self {
        return .init(width: lhs.width * rhs.width, height: lhs.height * rhs.height)
    }
    
    @inlinable
    static func * < Value : BinaryInteger >(lhs: Self, rhs: Value) -> Self {
        return .init(width: lhs.width * Double(rhs), height: lhs.height * Double(rhs))
    }
    
    @inlinable
    static func * < Value : BinaryInteger >(lhs: Value, rhs: Self) -> Self {
        return .init(width: Double(lhs) * rhs.width, height: Double(lhs) * rhs.height)
    }
    
    @inlinable
    static func * < Value : BinaryFloatingPoint >(lhs: Self, rhs: Value) -> Self {
        return .init(width: lhs.width * Double(rhs), height: lhs.height * Double(rhs))
    }
    
    @inlinable
    static func * < Value : BinaryFloatingPoint >(lhs: Value, rhs: Self) -> Self {
        return .init(width: Double(lhs) * rhs.width, height: Double(lhs) * rhs.height)
    }
    
    @inlinable
    static func * (lhs: Self, rhs: Distance) -> Self {
        return .init(width: lhs.width * rhs.value, height: lhs.height * rhs.value)
    }
    
    @inlinable
    static func * (lhs: Self, rhs: Percent) -> Self {
        return .init(width: lhs.width * rhs.value, height: lhs.height * rhs.value)
    }
    
}

public extension Size {
    
    @inlinable
    static func *= (lhs: inout Self, rhs: Self) {
        lhs = lhs * rhs
    }
    
    @inlinable
    static func *= (lhs: inout Self, rhs: Distance) {
        lhs = lhs * rhs
    }
    
    @inlinable
    static func *= (lhs: inout Self, rhs: Percent) {
        lhs = lhs * rhs
    }
    
}

public extension Size {
    
    @inlinable
    static func / (lhs: Self, rhs: Self) -> Self {
        return Size(width: lhs.width / rhs.width, height: lhs.height / rhs.height)
    }
    
    @inlinable
    static func / < Value : BinaryInteger >(lhs: Self, rhs: Value) -> Self {
        return .init(width: lhs.width / Double(rhs), height: lhs.height / Double(rhs))
    }
    
    @inlinable
    static func / < Value : BinaryInteger >(lhs: Value, rhs: Self) -> Self {
        return .init(width: Double(lhs) / rhs.width, height: Double(lhs) / rhs.height)
    }
    
    @inlinable
    static func / < Value : BinaryFloatingPoint >(lhs: Self, rhs: Value) -> Self {
        return .init(width: lhs.width / Double(rhs), height: lhs.height / Double(rhs))
    }
    
    @inlinable
    static func / < Value : BinaryFloatingPoint >(lhs: Value, rhs: Self) -> Self {
        return .init(width: Double(lhs) / rhs.width, height: Double(lhs) / rhs.height)
    }
    
    @inlinable
    static func / (lhs: Self, rhs: Distance) -> Self {
        return Size(width: lhs.width / rhs.value, height: lhs.height / rhs.value)
    }
    
    @inlinable
    static func / (lhs: Self, rhs: Percent) -> Self {
        return Size(width: lhs.width / rhs.value, height: lhs.height / rhs.value)
    }
    
}

public extension Size {
    
    @inlinable
    static func /= (lhs: inout Self, rhs: Self) {
        lhs = lhs / rhs
    }
    
    @inlinable
    static func /= (lhs: inout Self, rhs: Distance) {
        lhs = lhs / rhs
    }
    
    @inlinable
    static func /= (lhs: inout Self, rhs: Percent) {
        lhs = lhs / rhs
    }
    
}

extension Size : Comparable {
    
    public static func < (lhs: Self, rhs: Self) -> Bool {
        return lhs.width < rhs.width && lhs.height < rhs.height
    }
    
}

extension Size : IMapable {
}

extension Size : INearEqutable {
    
    @inlinable
    public static func ~~ (lhs: Self, rhs: Self) -> Bool {
        return lhs.width ~~ rhs.width && lhs.height ~~ rhs.height
    }
    
}

extension Size : ILerpable {
    
    @inlinable
    public func lerp(_ to: Self, progress: Percent) -> Self {
        let width = self.width.lerp(to.width, progress: progress)
        let height = self.height.lerp(to.height, progress: progress)
        return Size(width: width, height: height)
    }
    
}
