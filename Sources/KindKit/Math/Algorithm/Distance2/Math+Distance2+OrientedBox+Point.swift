//
//  KindKit
//

import Foundation

extension Math.Distance2 {
    
    public typealias OrientedBoxToPoint = PointToOrientedBox
    
    @inlinable
    public static func find(_ box: OrientedBox2, _ point: Point) -> OrientedBoxToPoint {
        return Self.find(point, box)
    }
    
}

public extension OrientedBox2 {
    
    @inlinable
    func distance(_ other: Point) -> Math.Distance2.OrientedBoxToPoint {
        return Math.Distance2.find(other, self)
    }
    
}
