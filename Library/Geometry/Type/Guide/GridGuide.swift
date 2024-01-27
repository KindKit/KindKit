//
//  KindKit
//

import KindNumeric
import KindMonadicMacro

@Monadic
public final class GridGuide : Guide {
    
    public var isEnabled: Bool = true
    
    @MonadicField
    public var size: Point
    
    @MonadicField
    public var snap: Point
    
    public init(
        isEnabled: Bool = true,
        size: Point,
        snap: Point
    ) {
        self.isEnabled = isEnabled
        self.size = size
        self.snap = snap
    }
    
    public func guide(_ coordinate: Point) -> Point {
        guard self.isEnabled == true else { return coordinate }
        let nx = coordinate.x.abs
        let ny = coordinate.y.abs
        let bx = (nx / self.size.x).roundedNearest
        let by = (ny / self.size.y).roundedNearest
        let gx = bx * self.size.x
        let gy = by * self.size.y
        let x = Self._guide(coordinate.x.isLessZero, nx, gx, self.snap.x)
        let y = Self._guide(coordinate.y.isLessZero, ny, gy, self.snap.y)
        if x == nil && y == nil {
            return coordinate
        }
        return .init(
            x: x ?? coordinate.x,
            y: y ?? coordinate.y
        )
    }
    
}

fileprivate extension GridGuide {
    
    static func _guide(_ isNegative: Bool, _ value: Coordinate, _ grid: Coordinate, _ snap: Coordinate) -> Coordinate? {
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
