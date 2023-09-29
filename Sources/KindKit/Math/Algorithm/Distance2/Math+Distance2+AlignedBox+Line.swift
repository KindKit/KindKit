//
//  KindKit
//

import Foundation

extension Math.Distance2 {
        
    @inlinable
    public static func find(_ box: AlignedBox2, _ line: Line2) -> LineToAlignedBox {
        return Self.find(line, box)
    }
    
}

public extension AlignedBox2 {
    
    @inlinable
    func distance(_ other: Line2) -> Math.Distance2.LineToAlignedBox {
        return Math.Distance2.find(other, self)
    }
    
}
