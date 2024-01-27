//
//  KindKit
//

import Foundation

public struct Rect : Hashable {
    
    public var origin: Point
    public var size: Size
    
    public init(size: Size) {
        self.origin = .zero
        self.size = size
    }
    
    public init(origin: Point, size: Size) {
        self.origin = origin
        self.size = size
    }
    
    public init(x: Double, y: Double, width: Double, height: Double) {
        self.origin = .init(x: x, y: y)
        self.size = .init(width: width, height: height)
    }
    
    public init(x: Double, y: Double, size: Size) {
        self.origin = .init(x: x, y: y)
        self.size = size
    }
    
    public init(topLeft: Point, bottomRight: Point) {
        self.origin = topLeft
        self.size = .init(width: bottomRight.x - topLeft.x, height: bottomRight.y - topLeft.y)
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
        self.size = .init(width: width, height: height)
    }
    
    public init(top: Point, size: Size) {
        self.origin = .init(x: top.x - size.width / 2, y: top.y)
        self.size = size
    }
    
    public init(top: Point, width: Double, height: Double) {
        self.origin = .init(x: top.x - width / 2, y: top.y)
        self.size = .init(width: width, height: height)
    }
    
    public init(topRight: Point, size: Size) {
        self.origin = .init(x: topRight.x - size.width, y: topRight.y)
        self.size = size
    }
    
    public init(topRight: Point, width: Double, height: Double) {
        self.origin = .init(x: topRight.x - width, y: topRight.y)
        self.size = .init(width: width, height: height)
    }
    
    public init(left: Point, size: Size) {
        self.origin = .init(x: left.x, y: left.y - size.height / 2)
        self.size = size
    }
    
    public init(left: Point, width: Double, height: Double) {
        self.origin = .init(x: left.x, y: left.y - height / 2)
        self.size = .init(width: width, height: height)
    }
    
    public init(center: Point, size: Size) {
        self.origin = .init(x: center.x - size.width / 2, y: center.y - size.height / 2)
        self.size = size
    }
    
    public init(center: Point, width: Double, height: Double) {
        self.origin = .init(x: center.x - width / 2, y: center.y - height / 2)
        self.size = .init(width: width, height: height)
    }
    
    public init(right: Point, size: Size) {
        self.origin = .init(x: right.x - size.width, y: right.y - size.height / 2)
        self.size = size
    }
    
    public init(right: Point, width: Double, height: Double) {
        self.origin = .init(x: right.x - width, y: right.y - height / 2)
        self.size = .init(width: width, height: height)
    }
    
    public init(bottomLeft: Point, size: Size) {
        self.origin = .init(x: bottomLeft.x, y: bottomLeft.y - size.height)
        self.size = size
    }
    
    public init(bottomLeft: Point, width: Double, height: Double) {
        self.origin = .init(x: bottomLeft.x, y: bottomLeft.y - height)
        self.size = .init(width: width, height: height)
    }
    
    public init(bottom: Point, size: Size) {
        self.origin = .init(x: bottom.x - size.width / 2, y: bottom.y - size.height)
        self.size = size
    }
    
    public init(bottom: Point, width: Double, height: Double) {
        self.origin = .init(x: bottom.x - width / 2, y: bottom.y - height)
        self.size = .init(width: width, height: height)
    }
    
    public init(bottomRight: Point, size: Size) {
        self.origin = .init(x: bottomRight.x - size.width, y: bottomRight.y - size.height)
        self.size = size
    }
    
    public init(bottomRight: Point, width: Double, height: Double) {
        self.origin = .init(x: bottomRight.x - width, y: bottomRight.y - height)
        self.size = .init(width: width, height: height)
    }
    
}

public extension Rect {
    
    @inlinable
    static var zero: Self {
        return .init(x: 0, y: 0, width: 0, height: 0)
    }
    
}

public extension Rect {
    
    @inlinable
    var isZero: Bool {
        return self ~~ .zero
    }
    
    @inlinable
    var x: Double {
        set { self.origin.x = newValue }
        get { self.origin.x }
    }
    
    @inlinable
    var minX: Double {
        set { self.origin.x = newValue }
        get { self.origin.x }
    }
    
    @inlinable
    var midX: Double {
        set { self.origin.x = newValue - (self.size.width / 2) }
        get { self.origin.x + (self.size.width / 2) }
    }
    
    @inlinable
    var maxX: Double {
        set { self.origin.x = newValue - self.size.width }
        get { self.origin.x + self.size.width }
    }
    
    @inlinable
    var y: Double {
        set { self.origin.y = newValue }
        get { self.origin.y }
    }
    
    @inlinable
    var minY: Double {
        set { self.origin.y = newValue }
        get { self.origin.y }
    }
    
    @inlinable
    var midY: Double {
        set { self.origin.y = newValue - (self.size.height / 2) }
        get { self.origin.y + (self.size.height / 2) }
    }
    
    @inlinable
    var maxY: Double {
        set { self.origin.y = newValue - self.size.height }
        get { self.origin.y + self.size.height }
    }
    
    @inlinable
    var width: Double {
        set { self.size.width = newValue }
        get { self.size.width }
    }

    @inlinable
    var height: Double {
        set { self.size.height = newValue }
        get { self.size.height }
    }

    @inlinable
    var topLeft: Point {
        set {
            self.minX = newValue.x
            self.minY = newValue.y
        }
        get {
            return .init(
                x: self.minX,
                y: self.minY
            )
        }
    }
    
    @inlinable
    var top: Point {
        set {
            self.midX = newValue.x
            self.minY = newValue.y
        }
        get {
            return .init(
                x: self.midX,
                y: self.minY
            )
        }
    }
    
    @inlinable
    var topRight: Point {
        set {
            self.maxX = newValue.x
            self.minY = newValue.y
        }
        get {
            return .init(
                x: self.maxX,
                y: self.minY
            )
        }
    }
    
    @inlinable
    var left: Point {
        set {
            self.minX = newValue.x
            self.midY = newValue.y
        }
        get {
            return .init(
                x: self.minX,
                y: self.midY
            )
        }
    }
    
    @inlinable
    var center: Point {
        set {
            self.midX = newValue.x
            self.midY = newValue.y
        }
        get {
            return .init(
                x: self.midX,
                y: self.midY
            )
        }
    }
    
    @inlinable
    var right: Point {
        set {
            self.maxX = newValue.x
            self.midY = newValue.y
        }
        get {
            return .init(
                x: self.maxX,
                y: self.midY
            )
        }
    }
    
    @inlinable
    var bottomLeft: Point {
        set {
            self.minX = newValue.x
            self.maxY = newValue.y
        }
        get {
            return .init(
                x: self.minX,
                y: self.maxY
            )
        }
    }
    
    @inlinable
    var bottom: Point {
        set {
            self.midX = newValue.x
            self.maxY = newValue.y
        }
        get {
            return .init(
                x: self.midX,
                y: self.maxY
            )
        }
    }
    
    @inlinable
    var bottomRight: Point {
        set {
            self.maxX = newValue.x
            self.maxY = newValue.y
        }
        get {
            return .init(
                x: self.maxX,
                y: self.maxY
            )
        }
    }
    
    @inlinable
    var integral: Self {
        return .init(
            x: self.x.roundDown,
            y: self.y.roundDown,
            width: self.width.roundUp,
            height: self.height.roundUp
        )
    }
    
    @inlinable
    var perimeter: Distance {
        return .init((self.width * 2) + (self.height * 2))
    }
    
    @inlinable
    var area: Area {
        return .init(self.width * self.height)
    }

}

public extension Rect {
    
    @inlinable
    func isContains(_ point: Point) -> Bool {
        guard self.minX <~ point.x && self.maxX >~ point.x else { return false }
        guard self.minY <~ point.y && self.maxY >~ point.y else { return false }
        return true
    }

    @inlinable
    func isContains(_ rect: Self) -> Bool {
        guard self.minX <~ rect.minX && self.maxX >= rect.maxX else { return false }
        guard self.minY <~ rect.minY && self.maxY >= rect.maxY else { return false }
        return true
    }

    @inlinable
    func isIntersects(_ rect: Self) -> Bool {
        guard self.minX <~ rect.maxX && self.maxX >~ rect.minX else { return false }
        guard self.minY <~ rect.maxY && self.maxY >~ rect.minY else { return false }
        return true
    }

    @inlinable
    func offset(_ point: Point) -> Self {
        return .init(topLeft: self.origin - point, size: self.size)
    }

    @inlinable
    func union(_ other: Self) -> Self {
        let lx = Swift.min(self.minX, other.minX)
        let ly = Swift.min(self.minY, other.minY)
        let ux = Swift.max(self.maxX, other.maxX)
        let uy = Swift.max(self.maxY, other.maxY)
        return .init(x: lx, y: ly, width: ux - lx, height: uy - ly)
    }
    
    @inlinable
    func split(left: Double) -> (left: Self, right: Self) {
        return (
            left: .init(x: self.x, y: self.y, width: left, height: self.height),
            right: .init(x: self.x + left, y: self.y, width: self.width - left, height: self.height)
        )
    }
    
    @inlinable
    func split(right: Double) -> (left: Self, right: Self) {
        return (
            left: .init(x: self.x, y: self.y, width: self.width - right, height: self.height),
            right: .init(x: self.maxX - right, y: self.y, width: right, height: self.height)
        )
    }
    
    @inlinable
    func split(left: Double, right: Double) -> (left: Self, middle: Self, right: Self) {
        return (
            left: .init(x: self.x, y: self.y, width: left, height: self.height),
            middle: .init(x: self.x + left, y: self.y, width: self.width - (left + right), height: self.height),
            right: .init(x: self.maxX - right, y: self.y, width: right, height: self.height)
        )
    }
    
    @inlinable
    func split(top: Double) -> (top: Self, bottom: Self) {
        return (
            top: .init(x: self.x, y: self.y, width: self.width, height: top),
            bottom: .init(x: self.x, y: self.y + top, width: self.width, height: self.height - top)
        )
    }
    
    @inlinable
    func split(bottom: Double) -> (top: Self, bottom: Self) {
        return (
            top: .init(x: self.x, y: self.y, width: self.width, height: self.height - bottom),
            bottom: .init(x: self.x, y: self.maxY - bottom, width: self.width, height: bottom)
        )
    }
    
    @inlinable
    func split(top: Double, bottom: Double) -> (top: Self, middle: Self, bottom: Self) {
        return (
            top: .init(x: self.x, y: self.y, width: self.width, height: top),
            middle: .init(x: self.x, y: self.y + top, width: self.width, height: self.height - (top + bottom)),
            bottom: .init(x: self.x, y: self.maxY - bottom, width: self.width, height: bottom)
        )
    }
    
    @inlinable
    func inset(_ inset: Inset) -> Self {
        return .init(x: self.x + inset.left, y: self.y + inset.top, size: self.size.inset(inset))
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
                    result.append(.init(origin: origin, size: itemSize))
                    origin.x += spacing.x
                }
                origin.y += spacing.y
            }
        }
        return result
    }
    
    @inlinable
    func aspectFit(_ size: Size) -> Self {
        return .init(center: self.center, size: self.size.aspectFit(size))
    }
    
    @inlinable
    func aspectFill(_ size: Size) -> Self {
        return .init(center: self.center, size: self.size.aspectFill(size))
    }
    
}

public extension Rect {
    
    @inlinable
    static prefix func - (arg: Self) -> Self {
        return .init(origin: -arg.origin, size: -arg.size)
    }
    
    @inlinable
    static func + (lhs: Self, rhs: Self) -> Self {
        return .init(origin: lhs.origin + rhs.origin, size: lhs.size + rhs.size)
    }
    
    @inlinable
    static func += (lhs: inout Self, rhs: Self) {
        lhs = lhs + rhs
    }
    
    @inlinable
    static func - (lhs: Self, rhs: Self) -> Self {
        return .init(origin: lhs.origin - rhs.origin, size: lhs.size - rhs.size)
    }
    
    @inlinable
    static func -= (lhs: inout Self, rhs: Self) {
        lhs = lhs - rhs
    }
    
    @inlinable
    static func * (lhs: Self, rhs: Self) -> Self {
        return .init(origin: lhs.origin * rhs.origin, size: lhs.size * rhs.size)
    }
    
    @inlinable
    static func *= (lhs: inout Self, rhs: Self) {
        lhs = lhs * rhs
    }
    
    @inlinable
    static func / (lhs: Self, rhs: Self) -> Self {
        return .init(origin: lhs.origin / rhs.origin, size: lhs.size / rhs.size)
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
        return .init(origin: origin, size: size)
    }
    
}
