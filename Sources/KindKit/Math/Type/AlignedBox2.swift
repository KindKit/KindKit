//
//  KindKit
//

import Foundation

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
        self.upper = .init(x: center.y + w2, y: center.y + h2)
    }
    
    public init(
        point1: Point,
        point2: Point
    ) {
        self.lower = point1.min(point2)
        self.upper = point1.max(point2)
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
    var height: Double {
        return Swift.max(self.upper.y - self.lower.y, 0)
    }
    
    @inlinable
    var size: Size {
        return .init(
            width: self.width,
            height: self.height
        )
    }
    
    @inlinable
    var area: Double {
        return self.width * self.height
    }
    
    @inlinable
    var topLeft: Point {
        return Point(x: self.lower.x, y: self.lower.y)
    }
    
    @inlinable
    var top: Point {
        return Point(x: self.lower.x + self.width / 2, y: self.lower.y)
    }
    
    @inlinable
    var topRight: Point {
        return Point(x: self.upper.x, y: self.lower.y)
    }
    
    @inlinable
    var left: Point {
        return Point(x: self.lower.x, y: self.lower.y + self.height / 2)
    }
    
    @inlinable
    var center: Point {
        return .init(x: self.lower.x + self.width / 2, y: self.lower.y + self.height / 2)
    }
    
    @inlinable
    var right: Point {
        return .init(x: self.upper.x, y: self.lower.y + self.height / 2)
    }
    
    @inlinable
    var bottomLeft: Point {
        return .init(x: self.lower.x, y: self.upper.y)
    }
    
    @inlinable
    var bottom: Point {
        return .init(x: self.lower.x + self.width / 2, y: self.lower.y + self.height)
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
