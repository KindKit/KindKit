//
//  KindKit
//

import KindNumeric

public struct OrientedBox2 : Hashable, Equatable {
    
    public var shape: AlignedBox2
    public var angle: Radian
    
    public init(
        shape: AlignedBox2,
        angle: Radian
    ) {
        self.shape = shape
        self.angle = angle
    }
    
}

public extension OrientedBox2 {
    
    @inlinable
    var width: Coordinate {
        return self.shape.width
    }
    
    @inlinable
    var height: Coordinate {
        return self.shape.height
    }
    
    @inlinable
    var size: Size {
        return self.shape.size
    }
    
    @inlinable
    var topLeft: Point {
        return self.shape.topLeft.rotated(
            by: self.angle,
            around: self.shape.center
        )
    }
    
    @inlinable
    var top: Point {
        return self.shape.topCenter.rotated(
            by: self.angle,
            around: self.shape.center
        )
    }
    
    @inlinable
    var topRight: Point {
        return self.shape.topRight.rotated(
            by: self.angle,
            around: self.shape.center
        )
    }
    
    @inlinable
    var left: Point {
        return self.shape.centerLeft.rotated(
            by: self.angle,
            around: self.shape.center
        )
    }
    
    @inlinable
    var center: Point {
        set { self.shape.center = newValue }
        get { self.shape.center }
    }
    
    @inlinable
    var right: Point {
        return self.shape.centerRight.rotated(
            by: self.angle,
            around: self.shape.center
        )
    }
    
    @inlinable
    var bottomLeft: Point {
        return self.shape.bottomLeft.rotated(
            by: self.angle,
            around: self.shape.center
        )
    }
    
    @inlinable
    var bottom: Point {
        return self.shape.bottomCenter.rotated(
            by: self.angle,
            around: self.shape.center
        )
    }
    
    @inlinable
    var bottomRight: Point {
        return self.shape.bottomRight.rotated(
            by: self.angle,
            around: self.shape.center
        )
    }
    
    @inlinable
    var bbox: AlignedBox2 {
        let matrix = Matrix3(rotation: self.angle)
        let pc = self.shape.center
        let ptl = self.shape.topLeft.rotated(by: matrix, around: pc)
        let ptr = self.shape.topRight.rotated(by: matrix, around: pc)
        let pbl = self.shape.bottomLeft.rotated(by: matrix, around: pc)
        let pbr = self.shape.bottomRight.rotated(by: matrix, around: pc)
        return .init([ ptl, ptr, pbr, pbl ])
    }
    
    @inlinable
    var polyline: Polyline2 {
        let matrix = Matrix3(rotation: self.angle)
        let pc = self.shape.center
        let ptl = self.shape.topLeft.rotated(by: matrix, around: pc)
        let ptr = self.shape.topRight.rotated(by: matrix, around: pc)
        let pbl = self.shape.bottomLeft.rotated(by: matrix, around: pc)
        let pbr = self.shape.bottomRight.rotated(by: matrix, around: pc)
        return .init([ ptl, ptr, pbr, pbl ])
    }
    
}

public extension OrientedBox2 {
    
    @inlinable
    init(
        center: Point,
        size: Size,
        angle: Radian
    ) {
        self.init(
            shape: .init(center: center, size: size),
            angle: angle
        )
    }
    
}

public extension OrientedBox2 {
    
    @inlinable
    func isContains(_ point: Point) -> Bool {
        let point = point.rotated(by: -self.angle, around: self.shape.center)
        return self.shape.isContains(point)
    }
    
}
