//
//  KindKit
//

import Foundation

public extension Center2 {
    
    static func find(
        polyline: Polyline2
    ) -> Point {
        
        let points = polyline.corners
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
        
        return Point(x: x / f, y: y / f)
    }
        
}

public extension Polyline2 {
    
    func center() -> Point {
        return Center2.find(polyline: self)
    }
    
}
