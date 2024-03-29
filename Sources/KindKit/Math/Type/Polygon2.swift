//
//  KindKit
//

import Foundation

public struct Polygon2 : Hashable {
    
    public var countours: [Polyline2] {
        didSet {
            self.bbox = Self._bbox(self.countours)
        }
    }
    public private(set) var bbox: AlignedBox2
    
    public init(
        countours: [Polyline2],
        bbox: AlignedBox2? = nil
    ) {
        self.countours = countours
        self.bbox = bbox ?? Self._bbox(countours)
    }
    
}

public extension Polygon2 {
    
    @inlinable
    var segments: [Segment2] {
        return self.countours.kk_reduce({ [] }, { $0.segments }, { $0 + $1.segments })
    }
    
    @inlinable
    var isEmpty: Bool {
        guard self.countours.isEmpty == false else { return false }
        for countour in self.countours {
            if countour.isEmpty == false {
                return false
            }
        }
        return true
    }
    
    @inlinable
    var perimeter: Distance {
        return self.countours.kk_reduce({ .zero }, { $0.perimeter }, { $0 + $1.perimeter })
    }

    @inlinable
    var area: Area {
        return self.countours.kk_reduce({ .zero }, { $0.area }, { $0 + $1.area })
    }
    
}

public extension Polygon2 {
    
    func isContains(_ point: Point, rule: Polyline2.FillRule = .winding) -> Bool {
        for countour in self.countours {
            if countour.isContains(point, rule: rule) == true {
                return true
            }
        }
        return false
    }
    
}

public extension Polygon2 {
    
    @inlinable
    static func * (lhs: Self, rhs: Matrix3) -> Self {
        return .init(countours: lhs.countours.map({ $0 * rhs }))
    }
    
}

public extension Polygon2 {
    
    @inlinable
    static func *= (lhs: inout Self, rhs: Matrix3) {
        lhs = lhs * rhs
    }
    
}

private extension Polygon2 {
    
    @inline(__always)
    static func _bbox(_ countours: [Polyline2]) -> AlignedBox2 {
        return countours.kk_reduce({ .zero }, { $0.bbox }, { $0.union($1.bbox) })
    }
    
}

extension Polygon2 : IMapable {
}
