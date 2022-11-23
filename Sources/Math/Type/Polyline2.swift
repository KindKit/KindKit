//
//  KindKit
//

import Foundation
import CoreGraphics

public struct Polyline2 : Hashable {
    
    public var corners: [Point] {
        didSet {
            self.edges = Self._edges(self.corners.count)
            self.bbox = Self._bbox(self.corners)
        }
    }
    public private(set) var edges: [Edge]
    public private(set) var bbox: Box2
    
    public init(
        corners: [Point],
        bbox: Box2? = nil
    ) {
        self.corners = corners
        self.edges = Self._edges(self.corners.count)
        self.bbox = bbox ?? Self._bbox(self.corners)
    }
    
}

public extension Polyline2 {
    
    enum FillRule {
        case winding
        case evenOdd
    }
    
}

public extension Polyline2 {
    
    @inlinable
    var polygon: Polygon2 {
        return Polygon2(countours: [ self ], bbox: self.bbox)
    }
    
    @inlinable
    var segments: [Segment2] {
        return self.edges.map({ self[segment: $0] })
    }
    
    @inlinable
    var isEmpty: Bool {
        return self.corners.isEmpty
    }
    
}

public extension Polyline2 {
    
    @inlinable
    func isValid(_ index: CornerIndex) -> Bool {
        return index.value >= self.corners.startIndex && index.value < self.corners.endIndex
    }
    
    @inlinable
    func isValid(_ index: EdgeIndex) -> Bool {
        return index.value >= self.edges.startIndex && index.value < self.edges.endIndex
    }
     
    func update(index: CornerIndex, closure: (_ corner: Point) -> Point) -> Self {
        guard self.isValid(index) == true else { return self }
        var cs = self.corners
        cs[index.value] = closure(cs[index.value])
        return Polyline2(corners: cs)
    }
    
    func update(index: EdgeIndex, closure: (_ segment: Segment2) -> Segment2) -> Self {
        guard self.isValid(index) == true else { return self }
        var cs = self.corners
        let e = self[edge: index]
        let s = closure(Segment2(start: cs[e.start.value], end: cs[e.end.value]))
        cs[e.start.value] = s.start
        cs[e.end.value] = s.end
        return Polyline2(corners: cs)
    }
    
    func offset(distance: Point) -> Self {
        guard distance !~ .zero else { return self }
        return Polyline2(corners: self.corners.map({ $0 + distance }))
    }
    
    func outline(distance: Double) -> Self {
        guard self.corners.count > 2 else { return self }
        guard distance !~ 0 else { return self }
        return Polyline2(
            corners: Array< Point >(unsafeUninitializedCapacity: self.corners.count, initializingWith: { buffer, count in
                var pe = self.edges[self.edges.count - 1]
                var ps = Segment2(start: self.corners[pe.start.value], end: self.corners[pe.end.value])
                var pn = ps.normal(at: .half)
                for index in 0..<self.edges.count {
                    let ne = self.edges[index]
                    let ns = Segment2(start: self.corners[ne.start.value], end: self.corners[ne.end.value])
                    let nn = ns.normal(at: .half)
                    let f = 1 + pn.dot(nn)
                    let cn = pn + nn
                    let n = cn / f
                    buffer[index] = ns.start + (n * distance)
                    pe = ne
                    ps = ns
                    pn = nn
                    count += 1
                }
            })
        )
    }
    
}

public extension Polyline2 {
    
    func isContains(_ point: Point, rule: FillRule = .winding) -> Bool {
        let count = self.edges.reduce(0, {
            $0 + self._windingCount(point, self[segment: $1])
        })
        switch rule {
        case .winding: return count != 0
        case .evenOdd: return count % 2 != 0
        }
    }

    func corner(_ point: Point, distance: Distance, condition: ((_ index: CornerIndex) -> Bool)? = nil) -> CornerIndex? {
        var corners: [(CornerIndex, Distance)] = []
        for index in self.corners.indices {
            let d = self.corners[index].distance(point).abs
            if d <= distance {
                corners.append((CornerIndex(index), d))
            }
        }
        if corners.isEmpty == true {
            return nil
        }
        let sorted = corners.sorted(by: { $0.1 < $1.1 })
        if let condition = condition {
            return sorted.first(where: { condition($0.0) })?.0
        }
        return sorted.first?.0
    }
    
    func edge(_ point: Point, distance: Distance, condition: ((_ index: EdgeIndex) -> Bool)? = nil) -> EdgeIndex? {
        var edges: [(EdgeIndex, Distance)] = []
        for index in self.edges.indices {
            let e = self.edges[index]
            let s = self[segment: e]
            let cp = s.closest(point)
            let ip = s.point(at: cp)
            let d = ip.distance(point).abs
            if d <= distance {
                edges.append((EdgeIndex(index), d))
            }
        }
        if corners.isEmpty == true {
            return nil
        }
        let sorted = edges.sorted(by: { $0.1 < $1.1 })
        if let condition = condition {
            return sorted.first(where: { condition($0.0) })?.0
        }
        return sorted.first?.0
    }
    
}

public extension Polyline2 {
    
    subscript(corner key: CornerIndex) -> Point {
        set { self.corners[key.value] = newValue }
        get { self.corners[key.value] }
    }
    
    subscript(edge key: EdgeIndex) -> Edge {
        return self.edges[key.value]
    }
    
    subscript(segment key: EdgeIndex) -> Segment2 {
        set { self[segment: self.edges[key.value]] = newValue }
        get { self[segment: self.edges[key.value]] }
    }
    
    subscript(segment key: Edge) -> Segment2 {
        set {
            self.corners[key.start.value] = newValue.start
            self.corners[key.end.value] = newValue.end
        }
        get {
            Segment2(
                start: self.corners[key.start.value],
                end: self.corners[key.end.value]
            )
        }
    }
    
    subscript(edges key: CornerIndex) -> (left: Edge, right: Edge)? {
        guard let left = self.edges.first(where: { $0.end == key }) else { return nil }
        guard let right = self.edges.first(where: { $0.start == key }) else { return nil }
        return (
            left: left,
            right: right
        )
    }
    
    subscript(edges key: EdgeIndex) -> (left: Edge, right: Edge)? {
        let edge = self.edges[key.value]
        guard let left = self.edges.first(where: { $0.end == edge.start }) else { return nil }
        guard let right = self.edges.first(where: { $0.start == edge.end }) else { return nil }
        return (
            left: left,
            right: right
        )
    }
    
    subscript(segments key: CornerIndex) -> (left: Segment2, right: Segment2)? {
        guard let edges = self[edges: key] else { return nil }
        return (
            left: self[segment: edges.left],
            right: self[segment: edges.right]
        )
    }
    
    subscript(segments key: EdgeIndex) -> (left: Segment2, right: Segment2)? {
        guard let edges = self[edges: key] else { return nil }
        return (
            left: self[segment: edges.left],
            right: self[segment: edges.right]
        )
    }
    
}

private extension Polyline2 {
    
    @inline(__always)
    static func _edges(_ total: Int) -> [Edge] {
        guard total > 1 else { return [] }
        return Array(unsafeUninitializedCapacity: total, initializingWith: { buffer, count in
            for i in 0..<total {
                buffer[i] = Edge(start: i, end: (i + 1) % total)
            }
            count = total
        })
    }
    
    @inline(__always)
    static func _bbox(_ corners: [Point]) -> Box2 {
        return corners.kk_reduce({
            return Box2()
        }, {
            return Box2(lower: $0, upper: $0)
        }, {
            return $0.union($1)
        })
    }
    
}

private extension Polyline2 {
    
    @inline(__always)
    func _windingCount(_ point: Point, _ segment: Segment2) -> Int {
        let bbox = segment.bbox
        if bbox.lower.x > point.x {
            return 0
        }
        let i = self._windingCountAdjustment(point.y, segment.start.y, segment.end.y)
        if i == 0 {
            return 0
        }
        if bbox.upper.x >= point.x {
            let t = (point.y - segment.start.y) / (segment.end.y - segment.start.y)
            let p = segment.point(at: Percent(t))
            guard point.x > p.x else {
                return 0
            }
        }
        return i
    }
    
    @inline(__always)
    func _windingCountAdjustment(_ value: Double, _ lower: Double, _ upper: Double) -> Int {
        if upper < value, value <= lower {
            return 1
        } else if lower < value, value <= upper {
            return -1
        }
        return 0
    }
    
}
