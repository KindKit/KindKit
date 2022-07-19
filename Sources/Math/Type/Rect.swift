//
//  KindKitMath
//

import Foundation

public typealias RectFloat = Rect< Float >
public typealias RectDouble = Rect< Double >

public struct Rect< Value : IScalar & Hashable > : Hashable {
    
    public var origin: Point< Value >
    public var size: Size< Value >
    
    @inlinable
    public init(origin: Point< Value >, size: Size< Value >) {
        self.origin = origin
        self.size = size
    }
    
    @inlinable
    public init(x: Value, y: Value, width: Value, height: Value) {
        self.origin = Point(x: x, y: y)
        self.size = Size(width: width, height: height)
    }
    
    @inlinable
    public init(x: Value, y: Value, size: Size< Value >) {
        self.origin = Point(x: x, y: y)
        self.size = size
    }
    
    @inlinable
    public init(topLeft: Point< Value >, bottomRight: Point< Value >) {
        self.origin = topLeft
        self.size = Size(width: bottomRight.x - topLeft.x, height: bottomRight.y - topLeft.y)
    }
    
    @inlinable
    public init(topLeft: Point< Value >, size: Size< Value >) {
        self.origin = topLeft
        self.size = size
    }
    
    @inlinable
    public init(topLeft: Point< Value >, width: Value, height: Value) {
        self.origin = topLeft
        self.size = Size(width: width, height: height)
    }
    
    @inlinable
    public init(top: Point< Value >, size: Size< Value >) {
        self.origin = Point(x: top.x - size.width / 2, y: top.y)
        self.size = size
    }
    
    @inlinable
    public init(top: Point< Value >, width: Value, height: Value) {
        self.origin = Point< Value >(x: top.x - width / 2, y: top.y)
        self.size = Size(width: width, height: height)
    }
    
    @inlinable
    public init(topRight: Point< Value >, size: Size< Value >) {
        self.origin = Point(x: topRight.x - size.width, y: topRight.y)
        self.size = size
    }
    
    @inlinable
    public init(topRight: Point< Value >, width: Value, height: Value) {
        self.origin = Point(x: topRight.x - width, y: topRight.y)
        self.size = Size(width: width, height: height)
    }
    
    @inlinable
    public init(left: Point< Value >, size: Size< Value >) {
        self.origin = Point(x: left.x, y: left.y - size.height / 2)
        self.size = size
    }
    
    @inlinable
    public init(left: Point< Value >, width: Value, height: Value) {
        self.origin = Point(x: left.x, y: left.y - height / 2)
        self.size = Size(width: width, height: height)
    }
    
    @inlinable
    public init(center: Point< Value >, size: Size< Value >) {
        self.origin = Point(x: center.x - size.width / 2, y: center.y - size.height / 2)
        self.size = size
    }
    
    @inlinable
    public init(center: Point< Value >, width: Value, height: Value) {
        self.origin = Point(x: center.x - width / 2, y: center.y - height / 2)
        self.size = Size(width: width, height: height)
    }
    
    @inlinable
    public init(right: Point< Value >, size: Size< Value >) {
        self.origin = Point(x: right.x - size.width, y: right.y - size.height / 2)
        self.size = size
    }
    
    @inlinable
    public init(right: Point< Value >, width: Value, height: Value) {
        self.origin = Point(x: right.x - width, y: right.y - height / 2)
        self.size = Size(width: width, height: height)
    }
    
    @inlinable
    public init(bottomLeft: Point< Value >, size: Size< Value >) {
        self.origin = Point(x: bottomLeft.x, y: bottomLeft.y - size.height)
        self.size = size
    }
    
    @inlinable
    public init(bottomLeft: Point< Value >, width: Value, height: Value) {
        self.origin = Point(x: bottomLeft.x, y: bottomLeft.y - height)
        self.size = Size(width: width, height: height)
    }
    
    @inlinable
    public init(bottom: Point< Value >, size: Size< Value >) {
        self.origin = Point(x: bottom.x - size.width / 2, y: bottom.y - size.height)
        self.size = size
    }
    
    @inlinable
    public init(bottom: Point< Value >, width: Value, height: Value) {
        self.origin = Point< Value >(x: bottom.x - width / 2, y: bottom.y - height)
        self.size = Size(width: width, height: height)
    }
    
    @inlinable
    public init(bottomRight: Point< Value >, size: Size< Value >) {
        self.origin = Point(x: bottomRight.x - size.width, y: bottomRight.y - size.height)
        self.size = size
    }
    
    @inlinable
    public init(bottomRight: Point< Value >, width: Value, height: Value) {
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
    var x: Value {
        return self.origin.x
    }
    
    @inlinable
    var y: Value {
        return self.origin.y
    }
    
    @inlinable
    var width: Value {
        return self.size.width
    }

    @inlinable
    var height: Value {
        return self.size.height
    }

    @inlinable
    var topLeft: Point< Value > {
        return Point(x: self.x, y: self.y)
    }
    
    @inlinable
    var top: Point< Value > {
        return Point(x: self.x + self.width / 2, y: self.y)
    }
    
    @inlinable
    var topRight: Point< Value > {
        return Point(x: self.x + self.width, y: self.y)
    }
    
    @inlinable
    var left: Point< Value > {
        return Point(x: self.x, y: self.y + self.height / 2)
    }
    
    @inlinable
    var center: Point< Value > {
        return Point(x: self.x + self.width / 2, y: self.y + self.height / 2)
    }
    
    @inlinable
    var right: Point< Value > {
        return Point(x: self.x + self.width, y: self.y + self.height / 2)
    }
    
    @inlinable
    var bottomLeft: Point< Value > {
        return Point(x: self.x, y: self.y + self.height)
    }
    
    @inlinable
    var bottom: Point< Value > {
        return Point(x: self.x + self.width / 2, y: self.y + self.height)
    }
    
    @inlinable
    var bottomRight: Point< Value > {
        return Point(x: self.x + self.width, y: self.y + self.height)
    }
    
    @inlinable
    var integral: Self {
        return Rect(x: self.x.roundDown, y: self.y.roundDown, width: self.width.roundUp, height: self.height.roundUp)
    }

}

public extension Rect {
    
    @inlinable
    func isContains(_ point: Point< Value >) -> Bool {
        guard self.x <= point.x && self.x + self.width >= point.x else { return false }
        guard self.y <= point.y && self.y + self.height >= point.y else { return false }
        return true
    }

    @inlinable
    func isContains(_ rect: Self) -> Bool {
        guard self.x <= rect.x && self.x + self.width >= rect.x + rect.width else { return false }
        guard self.y <= rect.y && self.y + self.height >= rect.y + rect.height else { return false }
        return true
    }

    @inlinable
    func isIntersects(_ rect: Self) -> Bool {
        guard self.x <= rect.x + rect.width && self.x + self.width >= rect.x else { return false }
        guard self.y <= rect.y + rect.height && self.y + self.height >= rect.y else { return false }
        return true
    }
    
    @inlinable
    func isHorizontalIntersects(_ rect: Self) -> Bool {
        guard self.x <= rect.x + rect.width && self.x + self.width >= rect.x else { return false }
        return true
    }
    
    @inlinable
    func isVerticalIntersects(_ rect: Self) -> Bool {
        guard self.y <= rect.y + rect.height && self.y + self.height >= rect.y else { return false }
        return true
    }

    @inlinable
    func offset(_ point: Point< Value >) -> Self {
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
    func split(left: Value) -> (left: Self, right: Self) {
        return (
            left: Rect(x: self.x, y: self.y, width: left, height: self.height),
            right: Rect(x: self.x + left, y: self.y, width: self.width - left, height: self.height)
        )
    }
    
    @inlinable
    func split(right: Value) -> (left: Self, right: Self) {
        return (
            left: Rect(x: self.x, y: self.y, width: self.width - right, height: self.height),
            right: Rect(x: (self.x + self.width) - right, y: self.y, width: right, height: self.height)
        )
    }
    
    @inlinable
    func split(left: Value, right: Value) -> (left: Self, middle: Self, right: Self) {
        return (
            left: Rect(x: self.x, y: self.y, width: left, height: self.height),
            middle: Rect(x: self.x + left, y: self.y, width: self.width - (left + right), height: self.height),
            right: Rect(x: (self.x + self.width) - right, y: self.y, width: right, height: self.height)
        )
    }
    
    @inlinable
    func split(top: Value) -> (top: Self, bottom: Self) {
        return (
            top: Rect(x: self.x, y: self.y, width: self.width, height: top),
            bottom: Rect(x: self.x, y: self.y + top, width: self.width, height: self.height - top)
        )
    }
    
    @inlinable
    func split(bottom: Value) -> (top: Self, bottom: Self) {
        return (
            top: Rect(x: self.x, y: self.y, width: self.width, height: self.height - bottom),
            bottom: Rect(x: self.x, y: (self.y + self.height) - bottom, width: self.width, height: bottom)
        )
    }
    
    @inlinable
    func split(top: Value, bottom: Value) -> (top: Self, middle: Self, bottom: Self) {
        return (
            top: Rect(x: self.x, y: self.y, width: self.width, height: top),
            middle: Rect(x: self.x, y: self.y + top, width: self.width, height: self.height - (top + bottom)),
            bottom: Rect(x: self.x, y: (self.y + self.height) - bottom, width: self.width, height: bottom)
        )
    }
    
    @inlinable
    func inset(_ inset: Inset< Value >) -> Self {
        return Rect(x: self.x + inset.left, y: self.y + inset.top, size: self.size.inset(inset))
    }
    
    @inlinable
    func grid(rows: UInt, columns: UInt, spacing: Point< Value >) -> [Self] {
        var result: [Rect< Value >] = []
        if rows > 0 && columns > 0 {
            var origin = self.origin
            let itemSize = Size(
                width: rows > 1 ? self.width / Value(rows - 1) : self.width,
                height: columns > 1 ? self.height / Value(columns - 1) : self.height
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
    func aspectFit(_ size: Size< Value >) -> Self {
        return Rect(center: self.center, size: self.size.aspectFit(size))
    }
    
    @inlinable
    func aspectFill(_ size: Size< Value >) -> Self {
        return Rect(center: self.center, size: self.size.aspectFill(size))
    }
    
    @inlinable
    func lerp(_ to: Self, progress: Value) -> Self {
        let origin = self.origin.lerp(to.origin, progress: progress)
        let size = self.size.lerp(to.size, progress: progress)
        return Rect(origin: origin, size: size)
    }
    
    @inlinable
    func lerp(_ to: Self, progress: Percent< Value >) -> Self {
        return self.lerp(to, progress: progress.value)
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

extension Rect : INearEqutable {
    
    @inlinable
    public static func ~~ (lhs: Self, rhs: Self) -> Bool {
        return lhs.origin ~~ rhs.origin && lhs.size ~~ rhs.size
    }
    
}

extension Rect : Comparable where Value : Comparable {
    
    public static func < (lhs: Self, rhs: Self) -> Bool {
        return lhs.origin < rhs.origin && lhs.size < rhs.size
    }
    
}
