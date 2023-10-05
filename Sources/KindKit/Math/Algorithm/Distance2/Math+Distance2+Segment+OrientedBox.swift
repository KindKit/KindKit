//
//  KindKit
//

import Foundation

extension Math.Distance2 {
    
    public struct SegmentToOrientedBox {
        
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
    
    public static func find(_ segment: Segment2, _ box: OrientedBox2) -> SegmentToOrientedBox {
        let l = segment.line
        let lr = Self.find(l, box)
        if lr.closest >~ 0 {
            if lr.closest <~ 1 {
                return .init(
                    closest: lr.closest,
                    src: lr.src,
                    dst: lr.dst
                )
            } else {
                let pr = Self.find(segment.end, box)
                return .init(
                    closest: 1,
                    src: segment.end,
                    dst: pr.dst
                )
            }
        } else {
            let pr = Self.find(segment.start, box)
            return .init(
                closest: 0,
                src: segment.start,
                dst: pr.dst
            )
        }
    }
    
}

public extension Segment2 {
    
    @inlinable
    func distance(_ other: OrientedBox2) -> Math.Distance2.SegmentToOrientedBox {
        return Math.Distance2.find(self, other)
    }
    
}
