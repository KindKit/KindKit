//
//  KindKit
//

import Foundation

extension Distance2 {
    
    public struct SegmentToAlignedBox : Equatable {
        
        public let segment: PointIntoLine
        public let box: Point
        public let squaredDistance: Distance.Squared
        
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
            return self.squaredDistance.normal
        }
        
    }
    
    public static func find(_ segment: Segment2, _ box: AlignedBox2) -> SegmentToAlignedBox {
        let l = segment.line
        let lr = Self.find(l, box)
        if lr.line.closest >~ .zero {
            if lr.line.closest <~ .one {
                return .init(
                    segment: lr.line,
                    box: lr.box
                )
            } else {
                let pr = Self.find(segment.end, box)
                return .init(
                    segment: .init(
                        closest: .one,
                        point: segment.end
                    ),
                    box: pr.box
                )
            }
        } else {
            let pr = Self.find(segment.start, box)
            return .init(
                segment: .init(
                    closest: .zero,
                    point: segment.start
                ),
                box: pr.box
            )
        }
    }
    
}

public extension Segment2 {
    
    @inlinable
    func distance(_ other: AlignedBox2) -> Distance2.SegmentToAlignedBox {
        return Distance2.find(self, other)
    }
    
}
