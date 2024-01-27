//
//  KindKit
//

import Foundation

extension Center2 {
    
    public static func find(points: [Point]) -> Point {
        var x: Double = 0
        var y: Double = 0
        var j = points.count - 1
        for i in 0..<points.count {
            let point1 = points[i]
            let point2 = points[j]
            let f = point1.x * point2.y - point2.x * point1.y
            x += (point1.x + point2.x) * f
            y += (point1.y + point2.y) * f
            j = i
        }
        
        var area: Double = 0
        j = points.count - 1
        for i in 0..<points.count {
            let point1 = points[i]
            let point2 = points[j]
            area += point1.x * point2.y
            area -= point1.y * point2.x
            j = i
        }
        area /= 2
        let f = area * 6
        return .init(
            x: x / f,
            y: y / f
        )
    }
        
}

public extension Array where Element == Point {
    
    @inlinable
    func kk_center() -> Point {
        return Center2.find(points: self)
    }
    
}
