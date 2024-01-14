//
//  KindKit
//

import Foundation

extension Distance2 {
    
    public typealias AlignedBoxToLine = LineToAlignedBox
    
    @inlinable
    public static func find(_ box: AlignedBox2, _ line: Line2) -> AlignedBoxToLine {
        return Self.find(line, box)
    }
    
}

public extension AlignedBox2 {
    
    @inlinable
    func distance(_ other: Line2) -> Distance2.AlignedBoxToLine {
        return Distance2.find(other, self)
    }
    
}
