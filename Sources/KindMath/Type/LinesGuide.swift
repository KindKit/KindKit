//
//  KindKit
//

public final class LinesGuide : IGuide {
    
    public var isEnabled: Bool
    public var lines: [Line2]
    public var snap: Distance
    
    public init(
        isEnabled: Bool = true,
        lines: [Line2],
        snap: Distance
    ) {
        self.isEnabled = isEnabled
        self.lines = lines
        self.snap = snap
    }
    
    public func guide(_ coordinate: Point) -> Point {
        guard self.isEnabled == true else { return coordinate }
        let oi = self.lines.map({ (line: $0, distance: $0.distance(coordinate)) })
        let fi = oi.filter({ $0.distance.abs <= self.snap })
        let si = fi.sorted(by: { $0.distance < $1.distance })
        if let i = si.first {
            return i.line.perpendicular(coordinate)
        }
        return coordinate
    }

}

public extension LinesGuide {
    
    @inlinable
    @discardableResult
    func lines(_ value: [Line2]) -> Self {
        self.lines = value
        return self
    }
    
    @inlinable
    @discardableResult
    func lines(_ value: () -> [Line2]) -> Self {
        return self.lines(value())
    }

    @inlinable
    @discardableResult
    func lines(_ value: (Self) -> [Line2]) -> Self {
        return self.lines(value(self))
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
