//
//  KindKit
//

import Foundation

extension Math.Intersection2 {
    
    public typealias AlignedBoxToLine = LineToAlignedBox
        
    @inlinable
    public static func possibly(_ box: AlignedBox2, _ line: Line2) -> Bool {
        return Self.possibly(line, box)
    }
    
    @inlinable
    public static func find(_ box: AlignedBox2, _ line: Line2) -> AlignedBoxToLine? {
        return Self.find(line, box)
    }
    
}

public extension AlignedBox2 {
    
    @inlinable
    func isIntersects(_ other: Line2) -> Bool {
        return Math.Intersection2.possibly(self, other)
    }
    
    @inlinable
    func intersection(_ other: Line2) -> Math.Intersection2.AlignedBoxToLine? {
        return Math.Intersection2.find(self, other)
    }
    
}
