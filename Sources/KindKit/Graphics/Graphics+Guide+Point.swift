//
//  KindKit
//

import Foundation

public extension Graphics.Guide {

    final class Point : IGraphicsGuide {
        
        public var isEnabled: Bool
        public var points: [KindKit.Point]
        public var snap: Distance
        
        public init(
            isEnabled: Bool = true,
            points: [KindKit.Point],
            snap: Distance
        ) {
            self.isEnabled = isEnabled
            self.points = points
            self.snap = snap
        }
        
        public func guide(_ coordinate: KindKit.Point) -> KindKit.Point {
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
    
}

public extension Graphics.Guide.Point {
    
    @inlinable
    @discardableResult
    func points(_ value: [KindKit.Point]) -> Self {
        self.points = value
        return self
    }
    
    @inlinable
    @discardableResult
    func points(_ value: () -> [KindKit.Point]) -> Self {
        return self.points(value())
    }

    @inlinable
    @discardableResult
    func points(_ value: (Self) -> [KindKit.Point]) -> Self {
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
