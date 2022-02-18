//
//  KindKitMath
//

import Foundation

public typealias RectFloat = Rect< Float >
public typealias RectDouble = Rect< Double >

public struct Rect< ValueType: BinaryFloatingPoint > : Hashable {
    
    public var origin: Point< ValueType >
    public var size: Size< ValueType >
    
    @inlinable
    public init(origin: Point< ValueType >, size: Size< ValueType >) {
        self.origin = origin
        self.size = size
    }
    
    @inlinable
    public init(x: ValueType, y: ValueType, width: ValueType, height: ValueType) {
        self.origin = Point(x: x, y: y)
        self.size = Size(width: width, height: height)
    }
    
    @inlinable
    public init(x: ValueType, y: ValueType, size: Size< ValueType >) {
        self.origin = Point(x: x, y: y)
        self.size = size
    }
    
    @inlinable
    public init(topLeft: Point< ValueType >, bottomRight: Point< ValueType >) {
        self.origin = topLeft
        self.size = Size(width: bottomRight.x - topLeft.x, height: bottomRight.y - topLeft.y)
    }
    
    @inlinable
    public init(topLeft: Point< ValueType >, size: Size< ValueType >) {
        self.origin = topLeft
        self.size = size
    }
    
    @inlinable
    public init(topLeft: Point< ValueType >, width: ValueType, height: ValueType) {
        self.origin = topLeft
        self.size = Size(width: width, height: height)
    }
    
    @inlinable
    public init(top: Point< ValueType >, size: Size< ValueType >) {
        self.origin = Point(x: top.x - size.width / 2, y: top.y)
        self.size = size
    }
    
    @inlinable
    public init(top: Point< ValueType >, width: ValueType, height: ValueType) {
        self.origin = Point< ValueType >(x: top.x - width / 2, y: top.y)
        self.size = Size(width: width, height: height)
    }
    
    @inlinable
    public init(topRight: Point< ValueType >, size: Size< ValueType >) {
        self.origin = Point(x: topRight.x - size.width, y: topRight.y)
        self.size = size
    }
    
    @inlinable
    public init(topRight: Point< ValueType >, width: ValueType, height: ValueType) {
        self.origin = Point(x: topRight.x - width, y: topRight.y)
        self.size = Size(width: width, height: height)
    }
    
    @inlinable
    public init(left: Point< ValueType >, size: Size< ValueType >) {
        self.origin = Point(x: left.x, y: left.y - size.height / 2)
        self.size = size
    }
    
    @inlinable
    public init(left: Point< ValueType >, width: ValueType, height: ValueType) {
        self.origin = Point(x: left.x, y: left.y - height / 2)
        self.size = Size(width: width, height: height)
    }
    
    @inlinable
    public init(center: Point< ValueType >, size: Size< ValueType >) {
        self.origin = Point(x: center.x - size.width / 2, y: center.y - size.height)
        self.size = size
    }
    
    @inlinable
    public init(center: Point< ValueType >, width: ValueType, height: ValueType) {
        self.origin = Point(x: center.x - width / 2, y: center.y - height / 2)
        self.size = Size(width: width, height: height)
    }
    
    @inlinable
    public init(right: Point< ValueType >, size: Size< ValueType >) {
        self.origin = Point(x: right.x - size.width, y: right.y - size.height / 2)
        self.size = size
    }
    
    @inlinable
    public init(right: Point< ValueType >, width: ValueType, height: ValueType) {
        self.origin = Point(x: right.x - width, y: right.y - height / 2)
        self.size = Size(width: width, height: height)
    }
    
    @inlinable
    public init(bottomLeft: Point< ValueType >, size: Size< ValueType >) {
        self.origin = Point(x: bottomLeft.x, y: bottomLeft.y - size.height)
        self.size = size
    }
    
    @inlinable
    public init(bottomLeft: Point< ValueType >, width: ValueType, height: ValueType) {
        self.origin = Point(x: bottomLeft.x, y: bottomLeft.y - height)
        self.size = Size(width: width, height: height)
    }
    
    @inlinable
    public init(bottom: Point< ValueType >, size: Size< ValueType >) {
        self.origin = Point(x: bottom.x - size.width / 2, y: bottom.y - size.height)
        self.size = size
    }
    
    @inlinable
    public init(bottom: Point< ValueType >, width: ValueType, height: ValueType) {
        self.origin = Point< ValueType >(x: bottom.x - width / 2, y: bottom.y - height)
        self.size = Size(width: width, height: height)
    }
    
    @inlinable
    public init(bottomRight: Point< ValueType >, size: Size< ValueType >) {
        self.origin = Point(x: bottomRight.x - size.width, y: bottomRight.y - size.height)
        self.size = size
    }
    
    @inlinable
    public init(bottomRight: Point< ValueType >, width: ValueType, height: ValueType) {
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
        return self.origin.isZero == true && self.size.isZero == true
    }
    
    @inlinable
    var x: ValueType {
        return self.origin.x
    }
    
    @inlinable
    var y: ValueType {
        return self.origin.y
    }
    
    @inlinable
    var width: ValueType {
        return self.size.width
    }

    @inlinable
    var height: ValueType {
        return self.size.height
    }

    @inlinable
    var topLeft: Point< ValueType > {
        return Point(x: self.x, y: self.y)
    }
    
    @inlinable
    var top: Point< ValueType > {
        return Point(x: self.x + self.width / 2, y: self.y)
    }
    
    @inlinable
    var topRight: Point< ValueType > {
        return Point(x: self.x + self.width, y: self.y)
    }
    
    @inlinable
    var left: Point< ValueType > {
        return Point(x: self.x, y: self.y + self.height / 2)
    }
    
    @inlinable
    var center: Point< ValueType > {
        return Point(x: self.x + self.width / 2, y: self.y + self.height / 2)
    }
    
    @inlinable
    var right: Point< ValueType > {
        return Point(x: self.x + self.width, y: self.y + self.height / 2)
    }
    
    @inlinable
    var bottomLeft: Point< ValueType > {
        return Point(x: self.x, y: self.y + self.height)
    }
    
    @inlinable
    var bottom: Point< ValueType > {
        return Point(x: self.x + self.width / 2, y: self.y + self.height)
    }
    
    @inlinable
    var bottomRight: Point< ValueType > {
        return Point(x: self.x + self.width, y: self.y + self.height)
    }
    
    @inlinable
    var integral: Self {
        return Rect(x: self.x.rounded(.down), y: self.y.rounded(.down), width: self.width.rounded(.up), height: self.height.rounded(.up))
    }

}

public extension Rect {
    
    @inlinable
    func isContains(point: Point< ValueType >) -> Bool {
        guard self.x <= point.x && self.x + self.width >= point.x else { return false }
        guard self.y <= point.y && self.y + self.height >= point.y else { return false }
        return true
    }

    @inlinable
    func isContains(rect: Self) -> Bool {
        guard self.x <= rect.x && self.x + self.width >= rect.x + rect.width else { return false }
        guard self.y <= rect.y && self.y + self.height >= rect.y + rect.height else { return false }
        return true
    }

    @inlinable
    func isIntersects(rect: Self) -> Bool {
        guard self.x <= rect.x + rect.width && self.x + self.width >= rect.x else { return false }
        guard self.y <= rect.y + rect.height && self.y + self.height >= rect.y else { return false }
        return true
    }
    
    @inlinable
    func isHorizontalIntersects(rect: Self) -> Bool {
        guard self.x <= rect.x + rect.width && self.x + self.width >= rect.x else { return false }
        return true
    }
    
    @inlinable
    func isVerticalIntersects(rect: Self) -> Bool {
        guard self.y <= rect.y + rect.height && self.y + self.height >= rect.y else { return false }
        return true
    }

    @inlinable
    func offset(point: Point< ValueType >) -> Self {
        return Rect(topLeft: self.origin - point, size: self.size)
    }

    @inlinable
    func union(_ to: Self) -> Self {
        let lx = Swift.min(self.x, to.x)
        let ly = Swift.min(self.y, to.y)
        let ux = Swift.max(self.x + self.width, to.x + to.width)
        let uy = Swift.max(self.y + self.height, to.y + to.height)
        return Rect(x: lx, y: ly, width: ux - lx, height: uy - ly)
    }
    
    @inlinable
    func split(left: ValueType) -> (left: Self, right: Self) {
        return (
            left: Rect(x: self.x, y: self.y, width: left, height: self.height),
            right: Rect(x: self.x + left, y: self.y, width: self.width - left, height: self.height)
        )
    }
    
    @inlinable
    func split(right: ValueType) -> (left: Self, right: Self) {
        return (
            left: Rect(x: self.x, y: self.y, width: self.width - right, height: self.height),
            right: Rect(x: (self.x + self.width) - right, y: self.y, width: right, height: self.height)
        )
    }
    
    @inlinable
    func split(left: ValueType, right: ValueType) -> (left: Self, middle: Self, right: Self) {
        return (
            left: Rect(x: self.x, y: self.y, width: left, height: self.height),
            middle: Rect(x: self.x + left, y: self.y, width: self.width - (left + right), height: self.height),
            right: Rect(x: (self.x + self.width) - right, y: self.y, width: right, height: self.height)
        )
    }
    
    @inlinable
    func split(top: ValueType) -> (top: Self, bottom: Self) {
        return (
            top: Rect(x: self.x, y: self.y, width: self.width, height: top),
            bottom: Rect(x: self.x, y: self.y + top, width: self.width, height: self.height - top)
        )
    }
    
    @inlinable
    func split(bottom: ValueType) -> (top: Self, bottom: Self) {
        return (
            top: Rect(x: self.x, y: self.y, width: self.width, height: self.height - bottom),
            bottom: Rect(x: self.x, y: (self.y + self.height) - bottom, width: self.width, height: bottom)
        )
    }
    
    @inlinable
    func split(top: ValueType, bottom: ValueType) -> (top: Self, middle: Self, bottom: Self) {
        return (
            top: Rect(x: self.x, y: self.y, width: self.width, height: top),
            middle: Rect(x: self.x, y: self.y + top, width: self.width, height: self.height - (top + bottom)),
            bottom: Rect(x: self.x, y: (self.y + self.height) - bottom, width: self.width, height: bottom)
        )
    }
    
    @inlinable
    func inset(_ inset: Inset< ValueType >) -> Self {
        return Rect(x: self.x + inset.left, y: self.y + inset.top, size: self.size.inset(inset))
    }
    
    @inlinable
    func grid(rows: UInt, columns: UInt, spacing: Point< ValueType >) -> [Self] {
        var result: [Rect< ValueType >] = []
        if rows > 0 && columns > 0 {
            var origin = self.origin
            let itemSize = Size(
                width: rows > 1 ? self.width / ValueType(rows - 1) : self.width,
                height: columns > 1 ? self.height / ValueType(columns - 1) : self.height
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
    func aspectFit(_ size: Size< ValueType >) -> Self {
        return Rect(center: self.center, size: self.size.aspectFit(size))
    }
    
    @inlinable
    func aspectFill(_ size: Size< ValueType >) -> Self {
        return Rect(center: self.center, size: self.size.aspectFill(size))
    }
    
    @inlinable
    func lerp(_ to: Self, progress: ValueType) -> Self {
        let origin = self.origin.lerp(to.origin, progress: progress)
        let size = self.size.lerp(to.size, progress: progress)
        return Rect(origin: origin, size: size)
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

extension Rect : Comparable where ValueType: Comparable {
    
    public static func < (lhs: Self, rhs: Self) -> Bool {
        return lhs.origin < rhs.origin && lhs.size < rhs.size
    }
    
}
