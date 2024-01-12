//
//  KindKit
//

import Foundation

extension Math.Distance2 {
    
    public struct PointToSegment : Equatable {
        
        public let point: Point
        public let segment: PointIntoLine
        public let squaredDistance: Distance.Squared
        
        init(
            point: Point,
            segment: PointIntoLine
        ) {
            self.point = point
            self.segment = segment
            self.squaredDistance = point.squaredLength(segment.point)
        }
        
        @inlinable
        public var distance: Distance {
            return self.squaredDistance.normal
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
            point: point,
            segment: .init(
                closest: .init(rclo),
                point: rpoi
            )
        )
    }
    
}

public extension Point {
    
    @inlinable
    func distance(_ other: Segment2) -> Math.Distance2.PointToSegment {
        return Math.Distance2.find(self, other)
    }
    
}
