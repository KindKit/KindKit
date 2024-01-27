//
//  KindKit
//

extension Distance2 {
    
    public struct PointToAlignedBox : Equatable {
        
        public let point: Point
        public let box: Point
        public let squaredDistance: SquaredDistance
        
        init(
            point: Point,
            box: Point
        ) {
            self.point = point
            self.box = box
            self.squaredDistance = point.squaredLength(box)
        }
        
        @inlinable
        public var distance: Distance {
            return self.squaredDistance.distance
        }
        
    }
    
    public static func find(_ point: Point, _ box: AlignedBox2) -> PointToAlignedBox {
        let s = box.size.halved()
        let o = point - box.center
        let rx = o.x.clamp(-s.width, s.width)
        let ry = o.y.clamp(-s.height, s.height)
        return .init(
            point: point,
            box: .init(x: rx, y: ry) + box.center
        )
    }
    
}

public extension Point {
    
    @inlinable
    func distance(_ other: AlignedBox2) -> Distance2.PointToAlignedBox {
        return Distance2.find(self, other)
    }
    
}
