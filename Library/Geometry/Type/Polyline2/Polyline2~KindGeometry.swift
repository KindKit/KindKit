//
//  KindKit
//

import KindNumeric

extension Polyline2 : PerimeterTrait {

    @inlinable
    public var perimeter: Coordinate {
        var length = Coordinate.zero
        for edge in self.edges {
            length += self[segment: edge].length.value
        }
        return length
    }

}

extension Polyline2 : AreaTrait {
    
    @inlinable
    public var area: Coordinate {
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
            result = result.halved().abs
        }
        return result
    }
    
}

extension Polyline2 : MulMatrix3Trait {
    
    @inlinable
    public func multiplying(by matrix: Matrix3) -> Self {
        return .init(self.corners.map({ $0.multiplying(by: matrix) }))
    }
    
}

extension Polyline2 : RotatedAroundPointTrait {
    
    @inlinable
    public func rotated(by matrix: Matrix3, around: Point) -> Self {
        return .init(self.corners.map({ $0.rotated(by: matrix, around: around) }))
    }
    
}
