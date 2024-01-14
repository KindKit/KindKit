//
//  KindKit
//

public final class PointGuide : IGuide {
    
    public var isEnabled: Bool
    public var points: [Point]
    public var snap: Distance
    
    public init(
        isEnabled: Bool = true,
        points: [Point],
        snap: Distance
    ) {
        self.isEnabled = isEnabled
        self.points = points
        self.snap = snap
    }
    
    public func guide(_ coordinate: Point) -> Point {
        guard self.isEnabled == true else { return coordinate }
        let oi = self.points.map({ (point: $0, distance: $0.length(coordinate)) })
        let fi = oi.filter({ $0.distance.abs <= self.snap })
        let si = fi.sorted(by: { $0.distance < $1.distance })
        if let i = si.first {
            return i.point
        }
        return coordinate
    }

}

public extension PointGuide {
    
    @inlinable
    @discardableResult
    func points(_ value: [Point]) -> Self {
        self.points = value
        return self
    }
    
    @inlinable
    @discardableResult
    func points(_ value: () -> [Point]) -> Self {
        return self.points(value())
    }

    @inlinable
    @discardableResult
    func points(_ value: (Self) -> [Point]) -> Self {
        return self.points(value(self))
    }
    
    @inlinable
    @discardableResult
    func snap(_ value: Distance) -> Self {
        self.snap = value
        return self
    }
    
    @inlinable
    @discardableResult
    func snap(_ value: () -> Distance) -> Self {
        return self.snap(value())
    }

    @inlinable
    @discardableResult
    func snap(_ value: (Self) -> Distance) -> Self {
        return self.snap(value(self))
    }
    
}
