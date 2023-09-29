//
//  KindKit
//

import Foundation

extension Math.Distance2 {
        
    @inlinable
    public static func find(_ box: OrientedBox2, _ line: Line2) -> LineToOrientedBox {
        return Self.find(line, box)
    }
    
}

public extension OrientedBox2 {
    
    @inlinable
    func distance(_ other: Line2) -> Math.Distance2.LineToOrientedBox {
        return Math.Distance2.find(self, other)
    }
    
}
