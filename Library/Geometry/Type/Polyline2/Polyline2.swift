//
//  KindKit
//

import KindNumeric

public struct Polyline2 : Hashable, Equatable {
    
    public var corners: [Point]
    
    public init(
        _ corners: [Point]
    ) {
        self.corners = corners
    }
    
}

public extension Polyline2 {

    subscript(corner index: CornerIndex) -> Point {
        set { self.corners[index.value] = newValue }
        get { self.corners[index.value] }
    }

    subscript(edge index: EdgeIndex) -> Edge {
        return .init(
            start: index.value.wrap(0, self.corners.count),
            end: (index.value + 1).wrap(0, self.corners.count)
        )
    }

    subscript(segment index: EdgeIndex) -> Segment2 {
        set { self[segment: self[edge: index]] = newValue }
        get { self[segment: self[edge: index]] }
    }

    subscript(segment edge: Edge) -> Segment2 {
        set {
            self.corners[edge.start.value] = newValue.start
            self.corners[edge.end.value] = newValue.end
        }
        get {
            return .init(
                start: self.corners[edge.start.value],
                end: self.corners[edge.end.value]
            )
        }
    }

    subscript(edges index: CornerIndex) -> (left: Edge, right: Edge) {
        return (
            left: .init(
                start: (index.value - 1).wrap(0, self.corners.count),
                end: index.value.wrap(0, self.corners.count)
            ),
            right: .init(
                start: index.value.wrap(0, self.corners.count),
                end: (index.value + 1).wrap(0, self.corners.count)
            )
        )
    }

    subscript(edges index: EdgeIndex) -> (left: Edge, right: Edge) {
        return (
            left: .init(
                start: (index.value - 2).wrap(0, self.corners.count),
                end: (index.value - 1).wrap(0, self.corners.count)
            ),
            right: .init(
                start: (index.value + 1).wrap(0, self.corners.count),
                end: (index.value + 2).wrap(0, self.corners.count)
            )
        )
    }

    subscript(segments key: CornerIndex) -> (left: Segment2, right: Segment2) {
        let edges = self[edges: key]
        return (
            left: self[segment: edges.left],
            right: self[segment: edges.right]
        )
    }

    subscript(segments key: EdgeIndex) -> (left: Segment2, right: Segment2) {
        let edges = self[edges: key]
        return (
            left: self[segment: edges.left],
            right: self[segment: edges.right]
        )
    }
    
}

public extension Polyline2 {
    
    @inlinable
    var isEmpty: Bool {
        return self.corners.isEmpty
    }
    
    @inlinable
    var isClockWise: Bool {
        var result = Coordinate.zero
        let edges = self.edges
        if edges.count > 2 {
            var p0 = self[corner: edges[edges.endIndex - 2].start]
            var p1 = self[corner: edges[edges.endIndex - 1].start]
            for edge in edges {
                let p2 = self[corner: edge.start]
                result += p1.x * (p2.y - p0.y)
                p0 = p1
                p1 = p2
            }
        }
        return result.isMoreZero
    }
    
    @inlinable
    var edges: [Edge] {
        let numberOfCorners = self.corners.count
        return Array< Edge >(unsafeUninitializedCapacity: numberOfCorners, initializingWith: { buffer, count in
            for i in 0 ..< numberOfCorners {
                buffer[i] = .init(start: i, end: (i + 1) % numberOfCorners)
            }
            count = numberOfCorners
        })
    }
    
    @inlinable
    var edgeIndecies: [EdgeIndex] {
        let numberOfCorners = self.corners.count
        return Array< EdgeIndex >(unsafeUninitializedCapacity: numberOfCorners, initializingWith: { buffer, count in
            for i in 0 ..< numberOfCorners {
                buffer[i] = .init(i)
            }
            count = numberOfCorners
        })
    }
    
    @inlinable
    var bbox: AlignedBox2 {
        return .init(self.corners)
    }
    
    @inlinable
    var polygon: Polygon2 {
        return .init([ self ])
    }
    
    @inlinable
    var segments: [Segment2] {
        return self.edges.map({ self[segment: $0] })
    }
    
}

public extension Polyline2 {
    
    @inlinable
    func isValid(_ index: CornerIndex) -> Bool {
        return index.value >= self.corners.startIndex && index.value < self.corners.endIndex
    }
    
    @inlinable
    func isValid(_ index: EdgeIndex) -> Bool {
        return index.value >= self.corners.startIndex && index.value < self.corners.endIndex
    }
    
    func isContains(_ point: Point, rule: FillRule = .winding) -> Bool {
        var count = 0
        for index in 0 ..< self.corners.count {
            count += self._windingCount(point, self[segment: EdgeIndex(index)])
        }
        switch rule {
        case .winding: return count != 0
        case .evenOdd: return count % 2 != 0
        }
    }
    
    func outline(distance: Distance) -> Self {
        guard self.corners.count > 2 else { return self }
        guard distance.isNotNearZero else { return self }
        return .init(Array< Point >(unsafeUninitializedCapacity: self.corners.count, initializingWith: { buffer, count in
            let edges = self.edges
            var pe = edges[edges.count - 1]
            var ps = Segment2(start: self.corners[pe.start.value], end: self.corners[pe.end.value])
            var pn = ps.normal(at: .half)
            for index in 0 ..< edges.count {
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
        }))
    }

    func corner(_ point: Point, distance: Distance, condition: ((_ index: CornerIndex) -> Bool)? = nil) -> CornerIndex? {
        var corners: [(CornerIndex, Distance)] = []
        for index in self.corners.indices {
            let d = self.corners[index].length(point).abs
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
    
    #warning("Need impl")
//    func edge(_ point: Point, distance: Distance, condition: ((_ index: EdgeIndex) -> Bool)? = nil) -> EdgeIndex? {
//        var edges: [(EdgeIndex, Distance)] = []
//        for index in self.edges.indices {
//            let e = self.edges[index]
//            let s = self[segment: e]
//            let cp = s.closest(point)
//            let ip = s.point(at: cp)
//            let d = ip.length(point).abs
//            if d <= distance {
//                edges.append((EdgeIndex(index), d))
//            }
//        }
//        if corners.isEmpty == true {
//            return nil
//        }
//        let sorted = edges.sorted(by: { $0.1 < $1.1 })
//        if let condition = condition {
//            return sorted.first(where: { condition($0.0) })?.0
//        }
//        return sorted.first?.0
//    }
    
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
    func _windingCountAdjustment(_ value: Coordinate, _ lower: Coordinate, _ upper: Coordinate) -> Int {
        if upper < value, value <= lower {
            return 1
        } else if lower < value, value <= upper {
            return -1
        }
        return 0
    }
    
}

