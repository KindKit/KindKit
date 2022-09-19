//
//  KindKit
//

import Foundation

public extension Graphics.Guide {
    
    final class Grid : IGraphicsGuide {
        
        public var isEnabled: Bool
        public var gridSize: PointFloat
        public var snapSize: PointFloat
        
        public init(
            isEnabled: Bool = true,
            gridSize: PointFloat,
            snapSize: PointFloat
        ) {
            self.isEnabled = isEnabled
            self.gridSize = gridSize
            self.snapSize = snapSize
        }
        
    }
    
}

extension Graphics.Guide.Grid : IGraphicsCoordinateGuide {
    
    public func guide(_ coordinate: PointFloat) -> PointFloat? {
        guard self.isEnabled == true else { return nil }
        let nx = coordinate.x.abs
        let ny = coordinate.y.abs
        let bx = (nx / self.gridSize.x).roundNearest
        let by = (ny / self.gridSize.y).roundNearest
        let gx = bx * self.gridSize.x
        let gy = by * self.gridSize.y
        let x = Self._guide(coordinate.x < 0, nx, gx, self.snapSize.x)
        let y = Self._guide(coordinate.y < 0, ny, gy, self.snapSize.y)
        if x == nil && y == nil {
            return nil
        }
        return PointFloat(
            x: x ?? coordinate.x,
            y: y ?? coordinate.y
        )
    }
    
}

private extension Graphics.Guide.Grid {
    
    static func _guide(_ isNegative: Bool, _ value: Float, _ grid: Float, _ snap: Float) -> Float? {
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
