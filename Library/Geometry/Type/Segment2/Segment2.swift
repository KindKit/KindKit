//
//  KindKit
//

import KindNumeric

public struct Segment2 : Hashable, Equatable {
    
    public var start: Point
    public var end: Point
    
    public init(
        start: Point,
        end: Point
    ) {
        self.start = start
        self.end = end
    }
    
}

public extension Segment2 {
    
    @inlinable
    var center: Point {
        return self.start + self.delta.halved()
    }
    
    @inlinable
    var delta: Point {
        return self.end - self.start
    }
    
    @inlinable
    var direction: Point {
        return self.delta.normalized.point
    }
    
    @inlinable
    var normal: Point {
        return self.delta.perpendicular.normalized.point
    }

    @inlinable
    var centeredForm: CenteredForm {
        set {
            self.start = newValue.center - (newValue.direction * newValue.extend)
            self.end = newValue.center + (newValue.direction * newValue.extend)
        }
        get {
            let n = self.delta.normalized
            return .init(
                center: self.center,
                direction: n.point,
                extend: n.length.distance.halved()
            )
        }
    }
    
    @inlinable
    var line: Line2 { 
        let cf = self.centeredForm
        return .init(
            origin: cf.center,
            direction: cf.direction
        )
    }
    
}

public extension Segment2 {
    
    @inlinable
    func direction(_ point: Point) -> Direction {
        let d = self.end - self.start
        let p = point - self.start
        let c = d.cross(p)
        if c.isMoreZero {
            return .left
        } else if c.isLessZero {
            return .right
        }
        return .inside
    }
    
}
