//
//  KindKit
//

import Foundation

extension Math.Intersection2 {
    
    public enum AlignedBoxToAlignedBox : Equatable {
        
        case none
        case box(AlignedBox2)
        
    }
        
    @inlinable
    public static func possibly(_ box1: AlignedBox2, _ box2: AlignedBox2) -> Bool {
        let l = Swift.max(box1.lower, box2.lower)
        let u = Swift.min(box1.upper, box2.upper)
        return u.x >= l.x && u.y >= l.y
    }
    
    @inlinable
    public static func find(_ box1: AlignedBox2, _ box2: AlignedBox2) -> AlignedBoxToAlignedBox {
        let l = Swift.max(box1.lower, box2.lower)
        let u = Swift.min(box1.upper, box2.upper)
        let d = u - l
        if d.x >= 0, d.y >= 0 {
            return .box(.init(lower: l, upper: u))
        }
        return .none
    }
    
}

public extension AlignedBox2 {
    
    @inlinable
    func isIntersects(_ other: Self) -> Bool {
        return Math.Intersection2.possibly(self, other)
    }
    
    @inlinable
    func intersection(_ other: Self) -> Self? {
        switch Math.Intersection2.find(self, other) {
        case .none: return nil
        case .box(let box): return box
        }
    }
    
}
