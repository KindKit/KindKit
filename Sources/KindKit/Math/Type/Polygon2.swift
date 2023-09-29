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
        return self.countours.kk_reduce({
            return []
        }, {
            return $0.segments
        }, {
            return $0 + $1.segments
        })
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
    
}

private extension Polygon2 {
    
    @inline(__always)
    static func _bbox(_ countours: [Polyline2]) -> AlignedBox2 {
        return countours.kk_reduce({
            return .zero
        }, {
            return $0.bbox
        }, {
            return $0.union($1.bbox)
        })
    }
    
}

extension Polygon2 : IMapable {
}
