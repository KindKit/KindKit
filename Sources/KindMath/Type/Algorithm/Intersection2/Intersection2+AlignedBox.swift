//
//  KindKit
//

import Foundation

extension Intersection2 {
    
    public struct AlignedBoxToAlignedBox : Equatable {
        
        public let box: AlignedBox2
        
        public init(box: AlignedBox2) {
            self.box = box
        }
        
    }
        
    @inlinable
    public static func possibly(_ box1: AlignedBox2, _ box2: AlignedBox2) -> Bool {
        let l = Swift.max(box1.lower, box2.lower)
        let u = Swift.min(box1.upper, box2.upper)
        return u.x >= l.x && u.y >= l.y
    }
    
    @inlinable
    public static func find(_ box1: AlignedBox2, _ box2: AlignedBox2) -> AlignedBoxToAlignedBox? {
        let l = Swift.max(box1.lower, box2.lower)
        let u = Swift.min(box1.upper, box2.upper)
        let d = u - l
        if d.x >= 0, d.y >= 0 {
            return .init(box: .init(lower: l, upper: u))
        }
        return nil
    }
    
}

public extension AlignedBox2 {
    
    @inlinable
    func isIntersects(_ other: AlignedBox2) -> Bool {
        return Intersection2.possibly(self, other)
    }
    
    @inlinable
    func intersection(_ other: AlignedBox2) -> Intersection2.AlignedBoxToAlignedBox? {
        return Intersection2.find(self, other)
    }
    
}
