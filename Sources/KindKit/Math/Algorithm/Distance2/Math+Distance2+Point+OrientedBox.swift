//
//  KindKit
//

import Foundation

extension Math.Distance2 {
    
    public struct PointToOrientedBox : Equatable {
        
        public let point: Point
        public let box: Point
        public let squaredDistance: Distance.Squared
        
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
            return self.squaredDistance.normal
        }
        
    }
    
    public static func find(_ point: Point, _ box: OrientedBox2) -> PointToOrientedBox {
        let im = Matrix3(rotation: -box.angle)
        let nm = Matrix3(rotation: box.angle)
        let p = point.rotated(by: im, around: box.center)
        let r = Self.find(p, box.shape)
        return .init(
            point: r.point.rotated(by: nm, around: box.center),
            box: r.box.rotated(by: nm, around: box.center)
        )
    }
    
}

public extension Point {
    
    @inlinable
    func distance(_ other: OrientedBox2) -> Math.Distance2.PointToOrientedBox {
        return Math.Distance2.find(self, other)
    }
    
}
