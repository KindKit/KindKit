//
//  KindKitMath
//

import Foundation
import CoreGraphics
import KindKitCore
import UIKit

public typealias Polygon2Float = Polygon2< Float >
public typealias Polygon2Double = Polygon2< Double >

public struct Polygon2< Value: IScalar & Hashable > : Hashable {
    
    public var countours: [Polyline2< Value >] {
        didSet {
            self.bbox = Self._bbox(self.countours)
        }
    }
    public private(set) var bbox: Box2< Value >
    
    public init(
        countours: [Polyline2< Value >],
        bbox: Box2< Value >? = nil
    ) {
        self.countours = countours
        self.bbox = bbox ?? Self._bbox(countours)
    }
    
}

public extension Polygon2 {
    
    @inlinable
    var segments: [Segment2< Value >] {
        return self.countours.reduce({
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
    static func _bbox(_ countours: [Polyline2< Value >]) -> Box2< Value > {
        return countours.reduce({
            return Box2< Value >()
        }, {
            return $0.bbox
        }, {
            return $0.union($1.bbox)
        })
    }
    
}
