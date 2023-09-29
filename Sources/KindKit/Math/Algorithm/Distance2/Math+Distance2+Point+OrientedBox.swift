//
//  KindKit
//

import Foundation

extension Math.Distance2 {
    
    public struct PointToOrientedBox {
        
        public let src: Point
        public let dst: Point
        
    }
    
    public static func find(_ point: Point, _ box: OrientedBox2) -> PointToOrientedBox {
        let im = Matrix3(rotation: -box.angle)
        let nm = Matrix3(rotation: box.angle)
        let p = point.rotated(by: im, around: box.center)
        let r = Self.find(p, box.shape)
        return .init(
            src: r.src.rotated(by: nm, around: box.center),
            dst: r.dst.rotated(by: nm, around: box.center)
        )
    }
    
}

public extension Point {
    
    @inlinable
    func distance(_ other: OrientedBox2) -> Math.Distance2.PointToOrientedBox {
        return Math.Distance2.find(self, other)
    }
    
}
