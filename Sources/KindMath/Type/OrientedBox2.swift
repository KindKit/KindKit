//
//  KindKit
//

import Foundation

public struct OrientedBox2 : Hashable {
    
    public var shape: AlignedBox2
    public var angle: Angle
    
    public init(
        shape: AlignedBox2,
        angle: Angle
    ) {
        self.shape = shape
        self.angle = angle
    }
    
    public init(
        center: Point,
        size: Size,
        angle: Angle
    ) {
        self.shape = .init(center: center, size: size)
        self.angle = angle
    }
    
}

public extension OrientedBox2 {
    
    @inlinable
    static var zero: Self {
        return .init(shape: .zero, angle: .degrees0)
    }
    
}

public extension OrientedBox2 {
    
    @inlinable
    var width: Double {
        return self.shape.width
    }
    
    @inlinable
    var halfWidth: Double {
        return self.shape.halfWidth
    }
    
    @inlinable
    var height: Double {
        return self.shape.height
    }
    
    @inlinable
    var halfHeight: Double {
        return self.shape.halfHeight
    }
    
    @inlinable
    var size: Size {
        return self.shape.size
    }
    
    @inlinable
    var topLeft: Point {
        return self.shape.topLeft.rotated(by: self.angle, around: self.shape.center)
    }
    
    @inlinable
    var top: Point {
        return self.shape.top.rotated(by: self.angle, around: self.shape.center)
    }
    
    @inlinable
    var topRight: Point {
        return self.shape.topRight.rotated(by: self.angle, around: self.shape.center)
    }
    
    @inlinable
    var left: Point {
        return self.shape.left.rotated(by: self.angle, around: self.shape.center)
    }
    
    @inlinable
    var center: Point {
        set { self.shape.center = newValue }
        get { self.shape.center }
    }
    
    @inlinable
    var right: Point {
        return self.shape.right.rotated(by: self.angle, around: self.shape.center)
    }
    
    @inlinable
    var bottomLeft: Point {
        return self.shape.bottomLeft.rotated(by: self.angle, around: self.shape.center)
    }
    
    @inlinable
    var bottom: Point {
        return self.shape.bottom.rotated(by: self.angle, around: self.shape.center)
    }
    
    @inlinable
    var bottomRight: Point {
        return self.shape.bottomRight.rotated(by: self.angle, around: self.shape.center)
    }
    
    @inlinable
    var perimeter: Distance {
        return self.shape.perimeter
    }
    
    @inlinable
    var area: Area {
        return self.shape.area
    }
    
    @inlinable
    var polyline: Polyline2 {
        let m = Matrix3(rotation: self.angle)
        let pc = self.shape.center
        let ptl = self.shape.topLeft.rotated(by: m, around: pc)
        let ptr = self.shape.topRight.rotated(by: m, around: pc)
        let pbl = self.shape.bottomLeft.rotated(by: m, around: pc)
        let pbr = self.shape.bottomRight.rotated(by: m, around: pc)
        return .init(corners: [ ptl, ptr, pbr, pbl ])
    }
    
    @inlinable
    var bbox: AlignedBox2 {
        let m = Matrix3(rotation: self.angle)
        let pc = self.shape.center
        let ptl = self.shape.topLeft.rotated(by: m, around: pc)
        let ptr = self.shape.topRight.rotated(by: m, around: pc)
        let pbl = self.shape.bottomLeft.rotated(by: m, around: pc)
        let pbr = self.shape.bottomRight.rotated(by: m, around: pc)
        return .init(
            lower: .init(
                x: Swift.min(ptl.x, ptr.x, pbl.x, pbr.x),
                y: Swift.min(ptl.y, ptr.y, pbl.y, pbr.y)
            ),
            upper: .init(
                x: Swift.max(ptl.x, ptr.x, pbl.x, pbr.x),
                y: Swift.max(ptl.y, ptr.y, pbl.y, pbr.y)
            )
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

extension OrientedBox2 : IMapable {
}

extension OrientedBox2 : ILerpable {
    
    @inlinable
    public func lerp(_ to: Self, progress: Percent) -> Self {
        return .init(
            shape: self.shape.lerp(to.shape, progress: progress),
            angle: self.angle.lerp(to.angle, progress: progress)
        )
    }
    
}
