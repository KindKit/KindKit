//
//  KindKit
//

import Foundation

extension Distance2 {
    
    public struct LineToOrientedBox : Equatable {
        
        public let line: PointIntoLine
        public let box: Point
        public let squaredDistance: Distance.Squared
        
        init(
            line: PointIntoLine,
            box: Point
        ) {
            self.line = line
            self.box = box
            self.squaredDistance = line.point.squaredLength(box)
        }
        
        @inlinable
        public var distance: Distance {
            return self.squaredDistance.normal
        }
        
    }
    
    public static func find(_ line: Line2, _ box: OrientedBox2) -> LineToOrientedBox {
        let im = Matrix3(rotation: -box.angle)
        let nm = Matrix3(rotation: box.angle)
        let l = line.rotated(by: im, around: box.center)
        let r = Self.find(l, box.shape)
        return .init(
            line: .init(
                closest: r.line.closest,
                point: r.line.point.rotated(by: nm, around: box.center)
            ),
            box: r.box.rotated(by: nm, around: box.center)
        )
    }
        
}

public extension Line2 {
    
    @inlinable
    func distance(_ other: OrientedBox2) -> Distance2.LineToOrientedBox {
        return Distance2.find(self, other)
    }
    
}
