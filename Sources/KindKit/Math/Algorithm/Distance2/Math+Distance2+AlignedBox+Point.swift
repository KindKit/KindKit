//
//  KindKit
//

import Foundation

extension Math.Distance2 {
    
    public typealias AlignedBoxToPoint = PointToAlignedBox
    
    @inlinable
    public static func find(_ box: AlignedBox2, _ point: Point) -> AlignedBoxToPoint {
        return Self.find(point, box)
    }
    
}

public extension AlignedBox2 {
    
    @inlinable
    func distance(_ other: Point) -> Math.Distance2.AlignedBoxToPoint {
        return Math.Distance2.find(other, self)
    }
    
}
