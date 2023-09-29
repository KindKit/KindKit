//
//  KindKit
//

import Foundation

public struct Rect : Hashable {
    
    public var origin: Point
    public var size: Size
    
    public init(origin: Point, size: Size) {
        self.origin = origin
        self.size = size
    }
    
    public init(x: Double, y: Double, width: Double, height: Double) {
        self.origin = Point(x: x, y: y)
        self.size = Size(width: width, height: height)
    }
    
    public init(x: Double, y: Double, size: Size) {
        self.origin = Point(x: x, y: y)
        self.size = size
    }
    
    public init(topLeft: Point, bottomRight: Point) {
        self.origin = topLeft
        self.size = Size(width: bottomRight.x - topLeft.x, height: bottomRight.y - topLeft.y)
    }
    
    public init(top: Rect) {
        self.init(bottomLeft: top.topLeft, size: top.size)
    }
    
    public init(left: Rect) {
        self.init(topRight: left.topLeft, size: left.size)
    }
    
    public init(right: Rect) {
        self.init(topLeft: right.topRight, size: right.size)
    }
    
    public init(bottom: Rect) {
        self.init(topLeft: bottom.bottomLeft, size: bottom.size)
    }
    
    public init(topLeft: Point, size: Size) {
        self.origin = topLeft
        self.size = size
    }
    
    public init(topLeft: Point, width: Double, height: Double) {
        self.origin = topLeft
        self.size = Size(width: width, height: height)
    }
    
    public init(top: Point, size: Size) {
        self.origin = Point(x: top.x - size.width / 2, y: top.y)
        self.size = size
    }
    
    public init(top: Point, width: Double, height: Double) {
        self.origin = Point(x: top.x - width / 2, y: top.y)
        self.size = Size(width: width, height: height)
    }
    
    public init(topRight: Point, size: Size) {
        self.origin = Point(x: topRight.x - size.width, y: topRight.y)
        self.size = size
    }
    
    public init(topRight: Point, width: Double, height: Double) {
        self.origin = Point(x: topRight.x - width, y: topRight.y)
        self.size = Size(width: width, height: height)
    }
    
    public init(left: Point, size: Size) {
        self.origin = Point(x: left.x, y: left.y - size.height / 2)
        self.size = size
    }
    
    public init(left: Point, width: Double, height: Double) {
        self.origin = Point(x: left.x, y: left.y - height / 2)
        self.size = Size(width: width, height: height)
    }
    
    public init(center: Point, size: Size) {
        self.origin = Point(x: center.x - size.width / 2, y: center.y - size.height / 2)
        self.size = size
    }
    
    public init(center: Point, width: Double, height: Double) {
        self.origin = Point(x: center.x - width / 2, y: center.y - height / 2)
        self.size = Size(width: width, height: height)
    }
    
    public init(right: Point, size: Size) {
        self.origin = Point(x: right.x - size.width, y: right.y - size.height / 2)
        self.size = size
    }
    
    public init(right: Point, width: Double, height: Double) {
        self.origin = Point(x: right.x - width, y: right.y - height / 2)
        self.size = Size(width: width, height: height)
    }
    
    public init(bottomLeft: Point, size: Size) {
        self.origin = Point(x: bottomLeft.x, y: bottomLeft.y - size.height)
        self.size = size
    }
    
    public init(bottomLeft: Point, width: Double, height: Double) {
        self.origin = Point(x: bottomLeft.x, y: bottomLeft.y - height)
        self.size = Size(width: width, height: height)
    }
    
    public init(bottom: Point, size: Size) {
        self.origin = Point(x: bottom.x - size.width / 2, y: bottom.y - size.height)
        self.size = size
    }
    
    public init(bottom: Point, width: Double, height: Double) {
        self.origin = Point(x: bottom.x - width / 2, y: bottom.y - height)
        self.size = Size(width: width, height: height)
    }
    
    public init(bottomRight: Point, size: Size) {
        self.origin = Point(x: bottomRight.x - size.width, y: bottomRight.y - size.height)
        self.size = size
    }
    
    public init(bottomRight: Point, width: Double, height: Double) {
        self.origin = Point(x: bottomRight.x - width, y: bottomRight.y - height)
        self.size = Size(width: width, height: height)
    }
    
}

public extension Rect {
    
    @inlinable
    static var zero: Self {
        return Rect(x: 0, y: 0, width: 0, height: 0)
    }
    
}

public extension Rect {
    
    @inlinable
    var isZero: Bool {
        return self ~~ .zero
    }
    
    @inlinable
    var x: Double {
        return self.origin.x
    }
    
    @inlinable
    var y: Double {
        return self.origin.y
    }
    
    @inlinable
    var width: Double {
        return self.size.width
    }

    @inlinable
    var height: Double {
        return self.size.height
    }

    @inlinable
    var topLeft: Point {
        return Point(x: self.x, y: self.y)
    }
    
    @inlinable
    var top: Point {
        return Point(x: self.x + self.width / 2, y: self.y)
    }
    
    @inlinable
    var topRight: Point {
        return Point(x: self.x + self.width, y: self.y)
    }
    
    @inlinable
    var left: Point {
        return Point(x: self.x, y: self.y + self.height / 2)
    }
    
    @inlinable
    var center: Point {
        return Point(x: self.x + self.width / 2, y: self.y + self.height / 2)
    }
    
    @inlinable
    var right: Point {
        return Point(x: self.x + self.width, y: self.y + self.height / 2)
    }
    
    @inlinable
    var bottomLeft: Point {
        return Point(x: self.x, y: self.y + self.height)
    }
    
    @inlinable
    var bottom: Point {
        return Point(x: self.x + self.width / 2, y: self.y + self.height)
    }
    
    @inlinable
    var bottomRight: Point {
        return Point(x: self.x + self.width, y: self.y + self.height)
    }
    
    @inlinable
    var integral: Self {
        return Rect(x: self.x.roundDown, y: self.y.roundDown, width: self.width.roundUp, height: self.height.roundUp)
    }

}

public extension Rect {
    
    @inlinable
    func isContains(_ point: Point) -> Bool {
        guard self.x <~ point.x && self.x + self.width >~ point.x else { return false }
        guard self.y <~ point.y && self.y + self.height >~ point.y else { return false }
        return true
    }

    @inlinable
    func isContains(_ rect: Self) -> Bool {
        guard self.x <~ rect.x && self.x + self.width >= rect.x + rect.width else { return false }
        guard self.y <~ rect.y && self.y + self.height >= rect.y + rect.height else { return false }
        return true
    }

    @inlinable
    func isIntersects(_ rect: Self) -> Bool {
        guard self.x <~ rect.x + rect.width && self.x + self.width >~ rect.x else { return false }
        guard self.y <~ rect.y + rect.height && self.y + self.height >~ rect.y else { return false }
        return true
    }
    
    @inlinable
    func isHorizontalIntersects(_ rect: Self) -> Bool {
        guard self.x <~ rect.x + rect.width && self.x + self.width >~ rect.x else { return false }
        return true
    }
    
    @inlinable
    func isVerticalIntersects(_ rect: Self) -> Bool {
        guard self.y <~ rect.y + rect.height && self.y + self.height >~ rect.y else { return false }
        return true
    }

    @inlinable
    func offset(_ point: Point) -> Self {
        return Rect(topLeft: self.origin - point, size: self.size)
    }

    @inlinable
    func union(_ other: Self) -> Self {
        let lx = Swift.min(self.x, other.x)
        let ly = Swift.min(self.y, other.y)
        let ux = Swift.max(self.x + self.width, other.x + other.width)
        let uy = Swift.max(self.y + self.height, other.y + other.height)
        return Rect(x: lx, y: ly, width: ux - lx, height: uy - ly)
    }
    
    @inlinable
    func split(left: Double) -> (left: Self, right: Self) {
        return (
            left: Rect(x: self.x, y: self.y, width: left, height: self.height),
            right: Rect(x: self.x + left, y: self.y, width: self.width - left, height: self.height)
        )
    }
    
    @inlinable
    func split(right: Double) -> (left: Self, right: Self) {
        return (
            left: Rect(x: self.x, y: self.y, width: self.width - right, height: self.height),
            right: Rect(x: (self.x + self.width) - right, y: self.y, width: right, height: self.height)
        )
    }
    
    @inlinable
    func split(left: Double, right: Double) -> (left: Self, middle: Self, right: Self) {
        return (
            left: Rect(x: self.x, y: self.y, width: left, height: self.height),
            middle: Rect(x: self.x + left, y: self.y, width: self.width - (left + right), height: self.height),
            right: Rect(x: (self.x + self.width) - right, y: self.y, width: right, height: self.height)
        )
    }
    
    @inlinable
    func split(top: Double) -> (top: Self, bottom: Self) {
        return (
            top: Rect(x: self.x, y: self.y, width: self.width, height: top),
            bottom: Rect(x: self.x, y: self.y + top, width: self.width, height: self.height - top)
        )
    }
    
    @inlinable
    func split(bottom: Double) -> (top: Self, bottom: Self) {
        return (
            top: Rect(x: self.x, y: self.y, width: self.width, height: self.height - bottom),
            bottom: Rect(x: self.x, y: (self.y + self.height) - bottom, width: self.width, height: bottom)
        )
    }
    
    @inlinable
    func split(top: Double, bottom: Double) -> (top: Self, middle: Self, bottom: Self) {
        return (
            top: Rect(x: self.x, y: self.y, width: self.width, height: top),
            middle: Rect(x: self.x, y: self.y + top, width: self.width, height: self.height - (top + bottom)),
            bottom: Rect(x: self.x, y: (self.y + self.height) - bottom, width: self.width, height: bottom)
        )
    }
    
    @inlinable
    func inset(_ inset: Inset) -> Self {
        return Rect(x: self.x + inset.left, y: self.y + inset.top, size: self.size.inset(inset))
    }
    
    @inlinable
    func grid(rows: UInt, columns: UInt, spacing: Point) -> [Self] {
        var result: [Rect] = []
        if rows > 0 && columns > 0 {
            var origin = self.origin
            let itemSize = Size(
                width: rows > 1 ? self.width / Double(rows - 1) : self.width,
                height: columns > 1 ? self.height / Double(columns - 1) : self.height
            )
            for _ in 0 ..< rows {
                origin.x = self.x
                for _ in 0 ..< columns {
                    result.append(Rect(origin: origin, size: itemSize))
                    origin.x += spacing.x
                }
                origin.y += spacing.y
            }
        }
        return result
    }
    
    @inlinable
    func aspectFit(_ size: Size) -> Self {
        return Rect(center: self.center, size: self.size.aspectFit(size))
    }
    
    @inlinable
    func aspectFill(_ size: Size) -> Self {
        return Rect(center: self.center, size: self.size.aspectFill(size))
    }
    
}

public extension Rect {
    
    @inlinable
    static prefix func - (arg: Self) -> Self {
        return Rect(origin: -arg.origin, size: -arg.size)
    }
    
    @inlinable
    static func + (lhs: Self, rhs: Self) -> Self {
        return Rect(origin: lhs.origin + rhs.origin, size: lhs.size + rhs.size)
    }
    
    @inlinable
    static func += (lhs: inout Self, rhs: Self) {
        lhs = lhs + rhs
    }
    
    @inlinable
    static func - (lhs: Self, rhs: Self) -> Self {
        return Rect(origin: lhs.origin - rhs.origin, size: lhs.size - rhs.size)
    }
    
    @inlinable
    static func -= (lhs: inout Self, rhs: Self) {
        lhs = lhs - rhs
    }
    
    @inlinable
    static func * (lhs: Self, rhs: Self) -> Self {
        return Rect(origin: lhs.origin * rhs.origin, size: lhs.size * rhs.size)
    }
    
    @inlinable
    static func *= (lhs: inout Self, rhs: Self) {
        lhs = lhs * rhs
    }
    
    @inlinable
    static func / (lhs: Self, rhs: Self) -> Self {
        return Rect(origin: lhs.origin / rhs.origin, size: lhs.size / rhs.size)
    }
    
    @inlinable
    static func /= (lhs: inout Self, rhs: Self) {
        lhs = lhs / rhs
    }
    
}

extension Rect : Comparable {
    
    public static func < (lhs: Self, rhs: Self) -> Bool {
        return lhs.origin < rhs.origin && lhs.size < rhs.size
    }
    
}

extension Rect : IMapable {
}

extension Rect : INearEqutable {
    
    @inlinable
    public static func ~~ (lhs: Self, rhs: Self) -> Bool {
        return lhs.origin ~~ rhs.origin && lhs.size ~~ rhs.size
    }
    
}

extension Rect : ILerpable {
    
    @inlinable
    public func lerp(_ to: Self, progress: Percent) -> Self {
        let origin = self.origin.lerp(to.origin, progress: progress)
        let size = self.size.lerp(to.size, progress: progress)
        return Rect(origin: origin, size: size)
    }
    
}
