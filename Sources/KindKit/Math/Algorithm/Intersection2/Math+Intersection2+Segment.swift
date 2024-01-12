//
//  KindKit
//

import Foundation

extension Math.Intersection2 {
    
    public enum SegmentToSegment : Equatable {
        
        case point(Point)
        case segment(Segment2)
        
        @inlinable
        public var point1: Point {
            switch self {
            case .point(let point): return point
            case .segment(let segment): return segment.start
            }
        }
        
        @inlinable
        public var point2: Point? {
            switch self {
            case .segment(let segment): return segment.end
            default: return nil
            }
        }
        
    }
        
    public static func possibly(_ segment1: Segment2, _ segment2: Segment2) -> Bool {
        let cf1 = segment1.centeredForm
        let cf2 = segment2.centeredForm
        let line1 = Line2(origin: cf1.center, direction: cf1.direction)
        let line2 = Line2(origin: cf2.center, direction: cf2.direction)
        switch Self.find(line1, line2) {
        case .parallel:
            let d = cf2.center - cf1.center
            let t = cf1.direction.dot(d)
            let i = Self.find(
                Range(uncheckedBounds: (lower: -cf1.extend.value, upper: cf1.extend.value)),
                Range(uncheckedBounds: (lower: t - cf2.extend.value, upper: t + cf2.extend.value))
            )
            switch i {
            case .none: return false
            case .one, .two: return true
            }
        case .point(let data):
            if data.parameter1.abs <= cf1.extend.value && data.parameter2.abs <= cf2.extend.value {
                return true
            }
            return false
        case .none:
            return false
        }
    }
    
    public static func find(_ segment1: Segment2, _ segment2: Segment2) -> SegmentToSegment? {
        let cf1 = segment1.centeredForm
        let cf2 = segment2.centeredForm
        let line1 = Line2(origin: cf1.center, direction: cf1.direction)
        let line2 = Line2(origin: cf2.center, direction: cf2.direction)
        switch Self.find(line1, line2) {
        case .parallel:
            let d = cf2.center - cf1.center
            let t = cf1.direction.dot(d)
            let i = Self.find(
                Range(uncheckedBounds: (lower: -cf1.extend.value, upper: cf1.extend.value)),
                Range(uncheckedBounds: (lower: t - cf2.extend.value, upper: t + cf2.extend.value))
            )
            switch i {
            case .one(let value):
                return .point(cf1.center + value * cf1.direction)
            case .two(let value1, let value2):
                return .segment(.init(
                    start: cf1.center + value1 * cf1.direction,
                    end: cf1.center + value2 * cf1.direction
                ))
            case .none:
                return nil
            }
        case .point(let data):
            if data.parameter1.abs <= cf1.extend.value && data.parameter2.abs <= cf2.extend.value {
                return .point(data.point)
            }
            return nil
        case .none:
            return nil
        }
    }
    
}

public extension Segment2 {
    
    @inlinable
    func isIntersects(_ other: Segment2) -> Bool {
        return Math.Intersection2.possibly(self, other)
    }
    
    @inlinable
    func intersection(_ other: Segment2) -> Math.Intersection2.SegmentToSegment? {
        return Math.Intersection2.find(self, other)
    }
    
}
