//
//  KindKitMath
//

import Foundation

public extension Intersection2 {
    
    enum SegmentToSegment : Equatable {
        case none
        case one(PointType)
        case two(PointType, PointType)
    }
    
}

public extension Intersection2.SegmentToSegment {
    
    @inlinable
    var point1: Intersection2.PointType? {
        switch self {
        case .one(let point): return point
        case .two(let point, _): return point
        default: return nil
        }
    }
    
    @inlinable
    var point2: Intersection2.PointType? {
        switch self {
        case .two(_, let point): return point
        default: return nil
        }
    }
    
}

public extension Intersection2 {
    
    static func possibly(_ segment1: SegmentType, _ segment2: SegmentType) -> Bool {
        let cf1 = segment1.centeredForm
        let cf2 = segment2.centeredForm
        let line1 = Line2(origin: cf1.center, direction: cf1.direction)
        let line2 = Line2(origin: cf2.center, direction: cf2.direction)
        switch Self.find(line1, line2) {
        case .none:
            return false
        case .parallel:
            let d = cf2.center - cf1.center
            let t = cf1.direction.dot(d)
            let i = Intersection2.find(
                Range(uncheckedBounds: (-cf1.extend, cf1.extend)),
                Range(uncheckedBounds: (t - cf2.extend, t + cf2.extend))
            )
            switch i {
            case .none: return false
            case .one, .two: return true
            }
        case .point(let data):
            if data.range.lowerBound.abs <= cf1.extend && data.range.upperBound.abs <= cf2.extend {
                return true
            }
            return false
        }
    }
    
    static func find(_ segment1: SegmentType, _ segment2: SegmentType) -> SegmentToSegment {
        let cf1 = segment1.centeredForm
        let cf2 = segment2.centeredForm
        let line1 = Line2(origin: cf1.center, direction: cf1.direction)
        let line2 = Line2(origin: cf2.center, direction: cf2.direction)
        switch Self.find(line1, line2) {
        case .none:
            return .none
        case .parallel:
            let d = cf2.center - cf1.center
            let t = cf1.direction.dot(d)
            let i = Intersection2.find(
                Range(uncheckedBounds: (-cf1.extend, cf1.extend)),
                Range(uncheckedBounds: (t - cf2.extend, t + cf2.extend))
            )
            switch i {
            case .none: return .none
            case .one(let value):
                return .one(cf1.center + value * cf1.direction)
            case .two(let value1, let value2):
                return .two(cf1.center + value1 * cf1.direction, cf1.center + value2 * cf1.direction)
            }
        case .point(let data):
            if data.range.lowerBound.abs <= cf1.extend && data.range.upperBound.abs <= cf2.extend {
                return .one(data.point)
            }
            return .none
        }
    }
    
}
