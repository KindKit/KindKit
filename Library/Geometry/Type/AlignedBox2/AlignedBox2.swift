//
//  KindKit
//

import KindNumeric

public struct AlignedBox2 : Hashable, Equatable {
    
    public var lower: Point
    public var upper: Point
    
    public init(
        lower: Point,
        upper: Point
    ) {
        self.lower = lower
        self.upper = upper
    }
    
}

public extension AlignedBox2 {
    
    @inlinable
    init(
        point1: Point,
        point2: Point
    ) {
        self.init(
            lower: point1.min(component: point2),
            upper: point1.max(component: point2)
        )
    }
    
}

public extension AlignedBox2 {
    
    @inlinable
    var width: Coordinate {
        return self.upper.x.subtracting(this: self.lower.x).min(.zero)
    }
    
    @inlinable
    var height: Coordinate {
        return self.upper.y.subtracting(this: self.lower.y).min(.zero)
    }
    
    @inlinable
    var size: Size {
        return .init(
            width: self.width,
            height: self.height
        )
    }
    
    @inlinable
    var topLeft: Point {
        set {
            self.lower.x = newValue.x
            self.lower.y = newValue.y
        }
        get {
            return .init(
                x: self.lower.x,
                y: self.lower.y
            )
        }
    }
    
    @inlinable
    var topCenter: Point {
        set {
            let width = self.width.halved()
            self.lower = .init(x: newValue.x - width, y: newValue.y)
            self.upper = .init(x: newValue.x + width, y: newValue.y + self.height)
        }
        get {
            return .init(
                x: self.lower.x + self.width.halved(),
                y: self.lower.y
            )
        }
    }
    
    @inlinable
    var topRight: Point {
        set {
            self.upper.x = newValue.x
            self.lower.y = newValue.y
        }
        get {
            return .init(
                x: self.upper.x,
                y: self.lower.y
            )
        }
    }
    
    @inlinable
    var centerLeft: Point {
        set {
            let size = self.size.halved()
            self.lower = .init(x: newValue.x - size.height, y: newValue.y - size.height)
            self.upper = .init(x: newValue.x + size.height, y: newValue.y + size.height)
        }
        get {
            return .init(
                x: self.upper.x + self.width.halved(),
                y: self.upper.y
            )
        }
    }
    
    @inlinable
    var center: Point {
        set {
            let size = self.size.halved()
            self.lower = .init(x: newValue.x - size.width, y: newValue.y - size.height)
            self.upper = .init(x: newValue.x + size.width, y: newValue.y + size.height)
        }
        get {
            return .init(
                x: self.lower.x + self.width.halved(),
                y: self.lower.y + self.height.halved()
            )
        }
    }
    
    @inlinable
    var centerRight: Point {
        set {
            let width = self.width.halved()
            self.lower = .init(x: newValue.x - width, y: newValue.y - self.height)
            self.upper = .init(x: newValue.x + width, y: newValue.y)
        }
        get {
            return .init(
                x: self.upper.x + self.width.halved(),
                y: self.upper.y
            )
        }
    }
    
    @inlinable
    var bottomLeft: Point {
        set {
            self.lower.x = newValue.x
            self.upper.y = newValue.y
        }
        get {
            return .init(
                x: self.lower.x,
                y: self.upper.y
            )
        }
    }
    
    @inlinable
    var bottomCenter: Point {
        set {
            let width = self.width.halved()
            self.lower = .init(x: newValue.x - width, y: newValue.y - self.height)
            self.upper = .init(x: newValue.x + width, y: newValue.y)
        }
        get {
            return .init(
                x: self.upper.x + self.width.halved(),
                y: self.upper.y
            )
        }
    }
    
    @inlinable
    var bottomRight: Point {
        set {
            self.upper.x = newValue.x
            self.upper.y = newValue.y
        }
        get {
            return .init(
                x: self.upper.x,
                y: self.upper.y
            )
        }
    }
    
    @inlinable
    var top: Coordinate {
        set { self.lower.x = newValue }
        get { return self.lower.x }
    }
    
    @inlinable
    var left: Coordinate {
        set { self.lower.y = newValue }
        get { return self.lower.y }
    }
    
    @inlinable
    var right: Coordinate {
        set { self.upper.y = newValue }
        get { return self.upper.y }
    }
    
    @inlinable
    var bottom: Coordinate {
        set { self.upper.x = newValue }
        get { return self.upper.x }
    }
    
    @inlinable
    var centeredForm: CenteredForm {
        return .init(
            center: self.upper.adding(on: self.lower).halved(),
            extent: self.upper.subtracting(this: self.lower).halved()
        )
    }
    
    @inlinable
    var polyline: Polyline2 {
        return .init([
            self.topLeft,
            self.topRight,
            self.bottomLeft,
            self.bottomRight
        ])
    }
    
}

public extension AlignedBox2 {
    
    @inlinable
    init(
        center: Point,
        size: Size
    ) {
        let w2 = size.width.halved()
        let h2 = size.height.halved()
        self.init(
            lower: .init(x: center.x - w2, y: center.y - h2),
            upper: .init(x: center.x + w2, y: center.y + h2)
        )
    }
    
    @inlinable
    init(
        _ rect: Rect
    ) {
        self.init(
            center: rect.center,
            size: rect.size
        )
    }
    
    @inlinable
    init(_ points: [Point]) {
        var lower: Point
        var upper: Point
        if points.isEmpty == false {
            lower = points[0]
            upper = lower
            for index in 1 ..< points.endIndex {
                let point = points[index]
                lower = lower.min(component: point)
                upper = upper.max(component: point)
            }
        } else {
            lower = .zero
            upper = .zero
        }
        self.init(lower: lower, upper: upper)
    }
    
}

public extension AlignedBox2 {
    
    @inlinable
    func isContains(_ point: Point) -> Bool {
        return point.x.isWithin(self.lower.x, self.upper.x)
            && point.y.isWithin(self.lower.y, self.upper.y)
    }
    
    @inlinable
    func union(_ other: Point) -> Self {
        return .init(
            lower: self.lower.min(component: other),
            upper: self.upper.max(component: other)
        )
    }
    
    @inlinable
    func union(_ other: Self) -> Self {
        return .init(
            lower: self.lower.min(component: other.lower),
            upper: self.upper.max(component: other.upper)
        )
    }
    
}
