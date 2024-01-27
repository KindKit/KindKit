//
//  KindKit
//

import Foundation

public extension Polyline2 {
    
    @inlinable
    func center() -> Point {
        return Center2.find(points: self.corners)
    }
    
}
