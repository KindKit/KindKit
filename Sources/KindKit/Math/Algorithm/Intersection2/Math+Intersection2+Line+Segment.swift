//
//  KindKit
//

import Foundation

extension Math.Intersection2 {
    
    public enum LineToSegment : Equatable {
        
        case one(Point)
        case two(Point, Point)
        
        @inlinable
        public var point1: Point {
            switch self {
            case .one(let point): return point
            case .two(let point, _): return point
            }
        }
        
        @inlinable
        public var point2: Point? {
            switch self {
            case .two(_, let point): return point
            default: return nil
            }
        }
        
    }
    
    public static func possibly(_ line: Line2, _ segment: Segment2) -> Bool {
        let sl = Line2(origin: segment.start, direction: segment.delta)
        switch Self.find(line, sl) {
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
    
    public static func find(_ line: Line2, _ segment: Segment2) -> LineToSegment? {
        let sl = Line2(origin: segment.start, direction: segment.delta)
        switch Self.find(line, sl) {
        case .parallel:
            return .two(segment.start, segment.end)
        case .point(let location):
            if location.parameter2 >= 0 && location.parameter2 <= 1 {
                return .one(location.point)
            }
            return nil
        case .none:
            return nil
        }
    }
    
}

public extension Line2 {
    
    @inlinable
    func isIntersects(_ other: Segment2) -> Bool {
        return Math.Intersection2.possibly(self, other)
    }
    
    @inlinable
    func intersection(_ other: Segment2) -> Math.Intersection2.LineToSegment? {
        return Math.Intersection2.find(self, other)
    }
    
}
