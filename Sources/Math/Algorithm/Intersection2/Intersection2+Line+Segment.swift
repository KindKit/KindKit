//
//  KindKitMath
//

import Foundation

public extension Intersection2 {
    
    enum LineToSegment : Equatable {
        case none
        case one(PointType)
        case two(PointType, PointType)
    }
    
}

public extension Intersection2.LineToSegment {
    
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
    
    static func possibly(_ line: LineType, _ segment: SegmentType) -> Bool {
        let sl = LineType(origin: segment.start, direction: segment.delta)
        switch Intersection2.find(line, sl) {
        case .none:
            return false
        case .parallel:
            return true
        case .point(let location):
            if location.parameter2 >= 0 && location.parameter2 <= 1 {
                return true
            }
            return false
        }
    }
    
    static func find(_ line: LineType, _ segment: SegmentType) -> LineToSegment {
        let sl = LineType(origin: segment.start, direction: segment.delta)
        switch Intersection2.find(line, sl) {
        case .none:
            return .none
        case .parallel:
            return .two(segment.start, segment.end)
        case .point(let location):
            if location.parameter2 >= 0 && location.parameter2 <= 1 {
                return .one(location.point)
            }
            return .none
        }
    }
    
}

public extension Line2 {
    
    @inlinable
    func isIntersects(_ other: Segment2< ValueType >) -> Bool {
        return Intersection2.possibly(self, other)
    }
    
    @inlinable
    func intersection(_ other: Segment2< ValueType >) -> Intersection2< ValueType >.LineToSegment {
        return Intersection2.find(self, other)
    }
    
}

public extension Segment2 {
    
    @inlinable
    func isIntersects(_ other: Line2< ValueType >) -> Bool {
        return Intersection2.possibly(other, self)
    }
    
    @inlinable
    func intersection(_ other: Line2< ValueType >) -> Intersection2< ValueType >.LineToSegment {
        return Intersection2.find(other, self)
    }
    
}
