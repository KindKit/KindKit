//
//  KindKit
//

import Foundation

extension Math.Distance2 {
        
    @inlinable
    public static func find(_ box: AlignedBox2, _ point: Point) -> PointToAlignedBox {
        return Self.find(point, box)
    }
    
}

public extension AlignedBox2 {
    
    @inlinable
    func distance(_ other: Point) -> Math.Distance2.PointToAlignedBox {
        return Math.Distance2.find(other, self)
    }
    
}
