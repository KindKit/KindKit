//
//  KindKit
//

import KindNumeric

extension Distance2 {
    
    public struct SegmentToOrientedBox : Equatable {
        
        public let segment: PointIntoLine
        public let box: Point
        public let squaredDistance: SquaredDistance
        
        init(
            segment: PointIntoLine,
            box: Point
        ) {
            self.segment = segment
            self.box = box
            self.squaredDistance = segment.point.squaredLength(box)
        }
        
        @inlinable
        public var distance: Distance {
            return self.squaredDistance.distance
        }
        
    }
    
    public static func find(_ segment: Segment2, _ box: OrientedBox2) -> SegmentToOrientedBox {
        let l = segment.line
        let lr = Self.find(l, box)
        if lr.line.closest >= .min {
            if lr.line.closest <= .max {
                return .init(
                    segment: lr.line,
                    box: lr.box
                )
            } else {
                let pr = Self.find(segment.end, box)
                return .init(
                    segment: .init(
                        closest: .max,
                        point: segment.end
                    ),
                    box: pr.box
                )
            }
        } else {
            let pr = Self.find(segment.start, box)
            return .init(
                segment: .init(
                    closest: .min,
                    point: segment.start
                ),
                box: pr.box
            )
        }
    }
    
}

public extension Segment2 {
    
    @inlinable
    func distance(_ other: OrientedBox2) -> Distance2.SegmentToOrientedBox {
        return Distance2.find(self, other)
    }
    
}
