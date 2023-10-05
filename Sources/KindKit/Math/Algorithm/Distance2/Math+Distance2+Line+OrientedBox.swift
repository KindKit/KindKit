//
//  KindKit
//

import Foundation

extension Math.Distance2 {
    
    public struct LineToOrientedBox {
        
        public let closest: Double
        public let src: Point
        public let dst: Point
        
        @inlinable
        public var distance: Distance {
            return self.squaredDistance.normal
        }
        
        @inlinable
        public var squaredDistance: Distance.Squared {
            return self.src.squaredLength(self.dst)
        }
        
    }
    
    public static func find(_ line: Line2, _ box: OrientedBox2) -> LineToOrientedBox {
        let im = Matrix3(rotation: -box.angle)
        let nm = Matrix3(rotation: box.angle)
        let l = line.rotated(by: im, around: box.center)
        let r = Self.find(l, box.shape)
        return .init(
            closest: r.closest,
            src: r.src.rotated(by: nm, around: box.center),
            dst: r.dst.rotated(by: nm, around: box.center)
        )
    }
        
}

public extension Line2 {
    
    @inlinable
    func distance(_ other: OrientedBox2) -> Math.Distance2.LineToOrientedBox {
        return Math.Distance2.find(self, other)
    }
    
}
