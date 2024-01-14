//
//  KindKit
//

import Foundation

extension Distance2 {
    
    public struct PointToAlignedBox : Equatable {
        
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
    
    public static func find(_ point: Point, _ box: AlignedBox2) -> PointToAlignedBox {
        let size = box.size / 2
        let o = point - box.center
        let rx = o.x.clamp(-size.width, size.width)
        let ry = o.y.clamp(-size.height, size.height)
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
