//
//  KindKit
//

import Foundation

extension Distance2 {
    
    public typealias OrientedBoxToLine = LineToOrientedBox
    
    @inlinable
    public static func find(_ box: OrientedBox2, _ line: Line2) -> OrientedBoxToLine {
        return Self.find(line, box)
    }
    
}

public extension OrientedBox2 {
    
    @inlinable
    func distance(_ other: Line2) -> Distance2.OrientedBoxToLine {
        return Distance2.find(self, other)
    }
    
}
