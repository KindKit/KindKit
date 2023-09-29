//
//  KindKit
//

import Foundation

extension Math.Distance2 {
        
    @inlinable
    public static func find(_ box: OrientedBox2, _ point: Point) -> PointToOrientedBox {
        return Self.find(point, box)
    }
    
}

public extension OrientedBox2 {
    
    @inlinable
    func distance(_ other: Point) -> Math.Distance2.PointToOrientedBox {
        return Math.Distance2.find(other, self)
    }
    
}
