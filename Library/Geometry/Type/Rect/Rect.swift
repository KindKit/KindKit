//
//  KindKit
//

import KindNumeric

public struct Rect : Hashable, Equatable {
    
    public var origin: Point
    public var size: Size
    
    public init(
        origin: Point,
        size: Size
    ) {
        self.origin = origin
        self.size = size
    }
    
    public init(
        x: Coordinate,
        y: Coordinate,
        width: Coordinate,
        height: Coordinate
    ) {
        self.origin = .init(x: x, y: y)
        self.size = .init(width: width, height: height)
    }
    
    public init(
        x: Coordinate,
        y: Coordinate,
        size: Size
    ) {
        self.origin = .init(x: x, y: y)
        self.size = size
    }
    
    public init(
        origin: Point,
        width: Coordinate,
        height: Coordinate
    ) {
        self.origin = origin
        self.size = .init(width: width, height: height)
    }
    
}

public extension Rect {
    
    @inlinable
    var x: Coordinate {
        set { self.origin.x = newValue }
        get { self.origin.x }
    }
    
    @inlinable
    var y: Coordinate {
        set { self.origin.y = newValue }
        get { self.origin.y }
    }
    
    @inlinable
    var width: Coordinate {
        set { self.size.width = newValue }
        get { self.size.width }
    }
    
    @inlinable
    var height: Coordinate {
        set { self.size.height = newValue }
        get { self.size.height }
    }
    
}

public extension Rect {
    
    @inlinable
    var minX: Coordinate {
        set { self.origin.x = newValue }
        get { self.origin.x }
    }
    
    @inlinable
    var midX: Coordinate {
        set { self.origin.x = newValue - self.size.width.halved() }
        get { self.origin.x + self.size.width.halved() }
    }
    
    @inlinable
    var maxX: Coordinate {
        set { self.origin.x = newValue - self.size.width }
        get { self.origin.x + self.size.width }
    }
    
    @inlinable
    var minY: Coordinate {
        set { self.origin.y = newValue }
        get { self.origin.y }
    }
    
    @inlinable
    var midY: Coordinate {
        set { self.origin.y = newValue - self.size.height.halved() }
        get { self.origin.y + self.size.height.halved() }
    }
    
    @inlinable
    var maxY: Coordinate {
        set { self.origin.y = newValue - self.size.height }
        get { self.origin.y + self.size.height }
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
            x: self.x.roundedDown,
            y: self.y.roundedDown,
            width: self.width.roundedUp,
            height: self.height.roundedUp
        )
    }
    
}

public extension Rect {
    
    @inlinable
    init(origin: Point) {
        self.init(
            origin: origin,
            size: .zero
        )
    }
    
    @inlinable
    init(size: Size) {
        self.init(
            origin: .zero,
            size: size
        )
    }
    
    @inlinable
    init(topLeft: Point, bottomRight: Point) {
        self.init(
            origin: topLeft,
            width: bottomRight.x - topLeft.x,
            height: bottomRight.y - topLeft.y
        )
    }
    
    @inlinable
    init(top: Self) {
        self.init(
            bottomLeft: top.topLeft,
            size: top.size
        )
    }
    
    @inlinable
    init(left: Self) {
        self.init(
            topRight: left.topLeft,
            size: left.size
        )
    }
    
    @inlinable
    init(right: Self) {
        self.init(
            topLeft: right.topRight,
            size: right.size
        )
    }
    
    @inlinable
    init(bottom: Self) {
        self.init(
            topLeft: bottom.bottomLeft,
            size: bottom.size
        )
    }
    
    @inlinable
    init(topLeft: Point, size: Size) {
        self.init(
            origin: topLeft,
            size: size
        )
    }
    
    @inlinable
    init(topLeft: Point, width: Coordinate, height: Coordinate) {
        self.init(
            origin: topLeft,
            width: width,
            height: height
        )
    }
    
    @inlinable
    init(top: Point, size: Size) {
        self.init(
            x: top.x - size.width.halved(),
            y: top.y,
            size: size
        )
    }
    
    @inlinable
    init(top: Point, width: Coordinate, height: Coordinate) {
        self.init(
            x: top.x - width.halved(),
            y: top.y,
            width: width,
            height: height
        )
    }
    
    @inlinable
    init(topRight: Point, size: Size) {
        self.init(
            x: topRight.x - size.width,
            y: topRight.y,
            size: size
        )
    }
    
    @inlinable
    init(topRight: Point, width: Coordinate, height: Coordinate) {
        self.init(
            x: topRight.x - width,
            y: topRight.y,
            width: width,
            height: height
        )
    }
    
    @inlinable
    init(left: Point, size: Size) {
        self.init(
            x: left.x,
            y: left.y - size.height.halved(),
            size: size
        )
    }
    
    @inlinable
    init(left: Point, width: Coordinate, height: Coordinate) {
        self.init(
            x: left.x,
            y: left.y - height.halved(),
            width: width,
            height: height
        )
    }
    
    @inlinable
    init(center: Point, size: Size) {
        self.init(
            x: center.x - size.width.halved(),
            y: center.y - size.height.halved(),
            size: size
        )
    }
    
    @inlinable
    init(center: Point, width: Coordinate, height: Coordinate) {
        self.init(
            x: center.x - width.halved(),
            y: center.y - height.halved(),
            width: width,
            height: height
        )
    }
    
    @inlinable
    init(right: Point, size: Size) {
        self.init(
            x: right.x - size.width,
            y: right.y - size.height.halved(),
            size: size
        )
    }
    
    @inlinable
    init(right: Point, width: Coordinate, height: Coordinate) {
        self.init(
            x: right.x - width,
            y: right.y - height.halved(),
            width: width,
            height: height
        )
    }
    
    @inlinable
    init(bottomLeft: Point, size: Size) {
        self.init(
            x: bottomLeft.x,
            y: bottomLeft.y - size.height,
            size: size
        )
    }
    
    @inlinable
    init(bottomLeft: Point, width: Coordinate, height: Coordinate) {
        self.init(
            x: bottomLeft.x,
            y: bottomLeft.y - height,
            width: width,
            height: height
        )
    }
    
    @inlinable
    init(bottom: Point, size: Size) {
        self.init(
            x: bottom.x - size.width.halved(),
            y: bottom.y - size.height,
            size: size
        )
    }
    
    @inlinable
    init(bottom: Point, width: Coordinate, height: Coordinate) {
        self.init(
            x: bottom.x - width.halved(),
            y: bottom.y - height,
            width: width,
            height: height
        )
    }
    
    @inlinable
    init(bottomRight: Point, size: Size) {
        self.init(
            x: bottomRight.x - size.width,
            y: bottomRight.y - size.height,
            size: size
        )
    }
    
    @inlinable
    init(bottomRight: Point, width: Coordinate, height: Coordinate) {
        self.init(
            x: bottomRight.x - width,
            y: bottomRight.y - height,
            width: width,
            height: height
        )
    }
    
}

public extension Rect {
    
    @inlinable
    func offset(_ point: Point) -> Self {
        return .init(
            topLeft: self.origin - point,
            size: self.size
        )
    }
    
    @inlinable
    func isContains(_ point: Point) -> Bool {
        guard self.minX.isLessOrEqual(point.x) && self.maxX.isMoreOrEqual(point.x) else { return false }
        guard self.minY.isLessOrEqual(point.y) && self.maxY.isMoreOrEqual(point.y) else { return false }
        return true
    }
    
    @inlinable
    func isContains(_ rect: Self) -> Bool {
        guard self.minX.isLessOrEqual(rect.minX) && self.maxX.isMoreOrEqual(rect.maxX) else { return false }
        guard self.minY.isLessOrEqual(rect.minY) && self.maxY.isMoreOrEqual(rect.maxY) else { return false }
        return true
    }
    
    @inlinable
    func isContains(_ point: Point, tolerance: Coordinate) -> Bool {
        guard self.minX.isLessOrEqual(point.x, tolerance: tolerance) && self.maxX.isMoreOrEqual(point.x, tolerance: tolerance) else { return false }
        guard self.minY.isLessOrEqual(point.y, tolerance: tolerance) && self.maxY.isMoreOrEqual(point.y, tolerance: tolerance) else { return false }
        return true
    }
    
    @inlinable
    func isContains(_ rect: Self, tolerance: Coordinate) -> Bool {
        guard self.minX.isLessOrEqual(rect.minX, tolerance: tolerance) && self.maxX.isMoreOrEqual(rect.maxX, tolerance: tolerance) else { return false }
        guard self.minY.isLessOrEqual(rect.minY, tolerance: tolerance) && self.maxY.isMoreOrEqual(rect.maxY, tolerance: tolerance) else { return false }
        return true
    }
    
    @inlinable
    func isIntersects(_ rect: Self) -> Bool {
        guard self.minX.isLessOrEqual(rect.maxX) && self.maxX.isMoreOrEqual(rect.minX) else { return false }
        guard self.minY.isLessOrEqual(rect.maxY) && self.maxY.isMoreOrEqual(rect.minY) else { return false }
        return true
    }
    
    @inlinable
    func isIntersects(_ rect: Self, tolerance: Coordinate) -> Bool {
        guard self.minX.isLessOrEqual(rect.maxX, tolerance: tolerance) && self.maxX.isMoreOrEqual(rect.minX, tolerance: tolerance) else { return false }
        guard self.minY.isLessOrEqual(rect.maxY, tolerance: tolerance) && self.maxY.isMoreOrEqual(rect.minY, tolerance: tolerance) else { return false }
        return true
    }
    
    @inlinable
    func union(_ other: Self) -> Self {
        let lx = self.minX.min(other.minX)
        let ly = self.minY.min(other.minY)
        let ux = self.maxX.max(other.maxX)
        let uy = self.maxY.max(other.maxY)
        return .init(
            x: lx,
            y: ly,
            width: ux - lx,
            height: uy - ly
        )
    }
    
    @inlinable
    func split(left: Coordinate) -> (left: Self, right: Self) {
        return (
            left: .init(x: self.x, y: self.y, width: left, height: self.height),
            right: .init(x: self.x + left, y: self.y, width: self.width - left, height: self.height)
        )
    }
    
    @inlinable
    func split(right: Coordinate) -> (left: Self, right: Self) {
        return (
            left: .init(x: self.x, y: self.y, width: self.width - right, height: self.height),
            right: .init(x: self.maxX - right, y: self.y, width: right, height: self.height)
        )
    }
    
    @inlinable
    func split(left: Coordinate, right: Coordinate) -> (left: Self, middle: Self, right: Self) {
        return (
            left: .init(x: self.x, y: self.y, width: left, height: self.height),
            middle: .init(x: self.x + left, y: self.y, width: self.width - (left + right), height: self.height),
            right: .init(x: self.maxX - right, y: self.y, width: right, height: self.height)
        )
    }
    
    @inlinable
    func split(top: Coordinate) -> (top: Self, bottom: Self) {
        return (
            top: .init(x: self.x, y: self.y, width: self.width, height: top),
            bottom: .init(x: self.x, y: self.y + top, width: self.width, height: self.height - top)
        )
    }
    
    @inlinable
    func split(bottom: Coordinate) -> (top: Self, bottom: Self) {
        return (
            top: .init(x: self.x, y: self.y, width: self.width, height: self.height - bottom),
            bottom: .init(x: self.x, y: self.maxY - bottom, width: self.width, height: bottom)
        )
    }
    
    @inlinable
    func split(top: Coordinate, bottom: Coordinate) -> (top: Self, middle: Self, bottom: Self) {
        return (
            top: .init(x: self.x, y: self.y, width: self.width, height: top),
            middle: .init(x: self.x, y: self.y + top, width: self.width, height: self.height - (top + bottom)),
            bottom: .init(x: self.x, y: self.maxY - bottom, width: self.width, height: bottom)
        )
    }
    
    func grid(rows: UInt, columns: UInt, spacing: Point) -> [Self] {
        var result: [Self] = []
        if rows > 0 && columns > 0 {
            var origin = self.origin
            let itemSize = Size(
                width: rows > 1 ? self.width / Coordinate(rows - 1) : self.width,
                height: columns > 1 ? self.height / Coordinate(columns - 1) : self.height
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
        return .init(
            center: self.center,
            size: self.size.aspectFit(size)
        )
    }
    
    @inlinable
    func aspectFill(_ size: Size) -> Self {
        return .init(
            center: self.center,
            size: self.size.aspectFill(size)
        )
    }
    
}
