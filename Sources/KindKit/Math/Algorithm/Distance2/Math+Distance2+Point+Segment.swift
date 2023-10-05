//
//  KindKit
//

import Foundation

extension Math.Distance2 {
    
    public struct PointToSegment {
        
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
    
    public static func find(_ point: Point, _ segment: Segment2) -> PointToSegment {
        let dr = segment.end - segment.start
        var df = point - segment.end
        var t = dr.dot(df)
        let rclo: Double
        let rpoi: Point
        if t >= 0 {
            rclo = 1
            rpoi = segment.end
        } else {
            df = point - segment.start
            t = dr.dot(df)
            if t <= 0 {
                rclo = 0
                rpoi = segment.start
            } else {
                let sl = dr.dot(dr)
                if sl > 0 {
                    rclo = t / sl
                    rpoi = segment.start + rclo * dr
                } else {
                    rclo = 0
                    rpoi = segment.start
                }
            }
        }
        return .init(
            closest: rclo,
            src: point,
            dst: rpoi
        )
    }
    
}

public extension Point {
    
    @inlinable
    func distance(_ other: Segment2) -> Math.Distance2.PointToSegment {
        return Math.Distance2.find(self, other)
    }
    
}
