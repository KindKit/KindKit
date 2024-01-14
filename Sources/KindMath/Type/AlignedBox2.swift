//
//  KindKit
//

import Foundation
import KindCore

public struct AlignedBox2 : Hashable {
    
    public var lower: Point
    public var upper: Point
    
    public init(
        lower: Point,
        upper: Point
    ) {
        self.lower = lower
        self.upper = upper
    }
    
    public init(
        center: Point,
        size: Size
    ) {
        let w2 = size.width / 2
        let h2 = size.height / 2
        self.lower = .init(x: center.x - w2, y: center.y - h2)
        self.upper = .init(x: center.x + w2, y: center.y + h2)
    }
    
    public init(
        point1: Point,
        point2: Point
    ) {
        self.lower = point1.min(point2)
        self.upper = point1.max(point2)
    }
    
    public init(
        _ points: [Point]
    ) {
        self = points.kk_reduce({ .zero }, { .init(lower: $0, upper: $0) }, { $0.union($1) })
    }
    
}

public extension AlignedBox2 {
    
    @inlinable
    static var zero: Self {
        return .init(lower: .zero, upper: .zero)
    }
    
    @inlinable
    static var empty: Self {
        return .init(lower: .infinity, upper: -.infinity)
    }
    
}

public extension AlignedBox2 {
    
    @inlinable
    var isEmpty: Bool {
        return self.lower.x > self.upper.x || self.lower.y > self.upper.y
    }
    
    @inlinable
    var width: Double {
        return Swift.max(self.upper.x - self.lower.x, 0)
    }
    
    @inlinable
    var halfWidth: Double {
        return self.width / 2
    }
    
    @inlinable
    var height: Double {
        return Swift.max(self.upper.y - self.lower.y, 0)
    }
    
    @inlinable
    var halfHeight: Double {
        return self.height / 2
    }
    
    @inlinable
    var size: Size {
        return .init(width: self.width, height: self.height)
    }
    
    @inlinable
    var halfSize: Size {
        return .init(width: self.halfWidth, height: self.halfHeight)
    }
    
    @inlinable
    var topLeft: Point {
        return Point(x: self.lower.x, y: self.lower.y)
    }
    
    @inlinable
    var top: Point {
        return Point(x: self.lower.x + self.halfWidth, y: self.lower.y)
    }
    
    @inlinable
    var topRight: Point {
        return Point(x: self.upper.x, y: self.lower.y)
    }
    
    @inlinable
    var left: Point {
        return Point(x: self.lower.x, y: self.lower.y + self.halfHeight)
    }
    
    @inlinable
    var center: Point {
        set {
            let hs = self.halfSize
            self.lower = .init(x: newValue.x - hs.width, y: newValue.y - hs.height)
            self.upper = .init(x: newValue.x + hs.width, y: newValue.y + hs.height)
        }
        get {
            return .init(
                x: self.lower.x + self.halfWidth,
                y: self.lower.y + self.halfHeight
            )
        }
    }
    
    @inlinable
    var right: Point {
        return .init(x: self.upper.x, y: self.lower.y + self.halfHeight)
    }
    
    @inlinable
    var bottomLeft: Point {
        return .init(x: self.lower.x, y: self.upper.y)
    }
    
    @inlinable
    var bottom: Point {
        return .init(x: self.lower.x + self.halfWidth, y: self.lower.y + self.height)
    }
    
    @inlinable
    var bottomRight: Point {
        return .init(x: self.upper.x, y: self.upper.y)
    }
    
    @inlinable
    var centeredForm: CenteredForm {
        return .init(
            center: (self.upper + self.lower) / 2,
            extent: (self.upper - self.lower) / 2
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
    
    @inlinable
    var polyline: Polyline2 {
        return .init(corners: [ 
            self.topLeft,
            self.topRight,
            self.bottomLeft,
            self.bottomRight
        ])
    }
    
}

public extension AlignedBox2 {
    
    @inlinable
    func isContains(_ point: Point) -> Bool {
        guard point.x >= self.lower.x && point.x <= self.upper.x else { return false }
        guard point.y >= self.lower.y && point.y <= self.upper.y else { return false }
        return true
    }
    
    @inlinable
    func union(_ other: Self) -> Self {
        return .init(
            lower: self.lower.min(other.lower),
            upper: self.upper.max(other.upper)
        )
    }
    
    @inlinable
    func union(_ other: Point) -> Self {
        return .init(
            lower: self.lower.min(other),
            upper: self.upper.max(other)
        )
    }
    
    @inlinable
    func inset(_ inset: Distance) -> Self {
        return .init(lower: self.lower - inset, upper: self.upper + inset)
    }
    
    @inlinable
    func rotated(by angle: Angle, around center: Point) -> OrientedBox2 {
        return .init(
            shape: .init(
                center: self.center.rotated(by: angle, around: center),
                size: self.size
            ),
            angle: angle
        )
    }
    
}

public extension AlignedBox2 {
    
    @inlinable
    static func * (lhs: Self, rhs: Matrix3) -> Self {
        let points = [
            lhs.topLeft * rhs,
            lhs.topRight * rhs,
            lhs.bottomLeft * rhs,
            lhs.bottomRight * rhs
        ]
        return .init(points)
    }
    
}

public extension AlignedBox2 {
    
    @inlinable
    static func *= (lhs: inout Self, rhs: Matrix3) {
        lhs = lhs * rhs
    }
        
}

extension AlignedBox2 : IMapable {
}

extension AlignedBox2 : ILerpable {
    
    @inlinable
    public func lerp(_ to: Self, progress: Percent) -> Self {
        return .init(
            lower: self.lower.lerp(to.lower, progress: progress),
            upper: self.upper.lerp(to.upper, progress: progress)
        )
    }
    
}
