//
//  KindKit
//

import Foundation

extension Math.Distance2 {
    
    public struct SegmentToAlignedBox {
        
        public let closest: Double
        public let src: Point
        public let dst: Point
        
    }
    
    public static func find(_ segment: Segment2, _ box: AlignedBox2) -> SegmentToAlignedBox {
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
    func distance(_ other: AlignedBox2) -> Math.Distance2.SegmentToAlignedBox {
        return Math.Distance2.find(self, other)
    }
    
}
