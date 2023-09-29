//
//  KindKit
//

import Foundation

extension Math.Distance2 {
    
    public struct PointToAlignedBox {
        
        public let src: Point
        public let dst: Point
        
    }
    
    public static func find(_ point: Point, _ box: AlignedBox2) -> PointToAlignedBox {
        let size = box.size / 2
        let o = point - box.center
        let rx = o.x.clamp(-size.width, size.width)
        let ry = o.y.clamp(-size.height, size.height)
        return .init(
            src: point,
            dst: .init(x: rx, y: ry) + box.center
        )
    }
    
}

public extension Point {
    
    @inlinable
    func distance(_ other: AlignedBox2) -> Math.Distance2.PointToAlignedBox {
        return Math.Distance2.find(self, other)
    }
    
}
