//
//  KindKit
//

import Foundation

public extension Graphics.Guide {
    
    final class Grid : IGraphicsGuide {
        
        public var isEnabled: Bool
        public var size: KindKit.Point
        public var snap: KindKit.Point
        
        public init(
            isEnabled: Bool = true,
            size: KindKit.Point,
            snap: KindKit.Point
        ) {
            self.isEnabled = isEnabled
            self.size = size
            self.snap = snap
        }
        
        public func guide(_ coordinate: KindKit.Point) -> KindKit.Point {
            guard self.isEnabled == true else { return coordinate }
            let nx = coordinate.x.abs
            let ny = coordinate.y.abs
            let bx = (nx / self.size.x).roundNearest
            let by = (ny / self.size.y).roundNearest
            let gx = bx * self.size.x
            let gy = by * self.size.y
            let x = Self._guide(coordinate.x < 0, nx, gx, self.snap.x)
            let y = Self._guide(coordinate.y < 0, ny, gy, self.snap.y)
            if x == nil && y == nil {
                return coordinate
            }
            return .init(
                x: x ?? coordinate.x,
                y: y ?? coordinate.y
            )
        }
        
    }
    
}

private extension Graphics.Guide.Grid {
    
    static func _guide(_ isNegative: Bool, _ value: Double, _ grid: Double, _ snap: Double) -> Double? {
        if value >= grid - snap && value <= grid + snap {
            if isNegative == true {
                return -grid
            } else {
                return grid
            }
        }
        return nil
    }
    
}

public extension Graphics.Guide.Grid {
    
    @inlinable
    @discardableResult
    func size(_ value: KindKit.Point) -> Self {
        self.size = value
        return self
    }
    
    @inlinable
    @discardableResult
    func size(_ value: () -> KindKit.Point) -> Self {
        return self.size(value())
    }

    @inlinable
    @discardableResult
    func size(_ value: (Self) -> KindKit.Point) -> Self {
        return self.size(value(self))
    }
    
    @inlinable
    @discardableResult
    func snap(_ value: KindKit.Point) -> Self {
        self.snap = value
        return self
    }
    
    @inlinable
    @discardableResult
    func snap(_ value: () -> KindKit.Point) -> Self {
        return self.snap(value())
    }

    @inlinable
    @discardableResult
    func snap(_ value: (Self) -> KindKit.Point) -> Self {
        return self.snap(value(self))
    }
    
}
