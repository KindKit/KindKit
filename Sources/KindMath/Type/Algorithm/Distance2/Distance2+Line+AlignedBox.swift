//
//  KindKit
//

import Foundation

extension Distance2 {
    
    public struct LineToAlignedBox : Equatable {
        
        public let line: PointIntoLine
        public let box: Point
        public let squaredDistance: Distance.Squared
        
        init(
            line: PointIntoLine,
            box: Point
        ) {
            self.line = line
            self.box = box
            self.squaredDistance = line.point.squaredLength(box)
        }
        
        @inlinable
        public var distance: Distance {
            return self.squaredDistance.normal
        }
        
    }
    
    public static func find(_ line: Line2, _ box: AlignedBox2) -> LineToAlignedBox {
        let cf = box.centeredForm
        var o = line.origin - cf.center
        var d = line.direction
        let e = cf.extent
        let rx, ry: Bool
        if d.x < 0 {
            o.x = -o.x
            d.x = -d.x
            rx = true
        } else {
            rx = false
        }
        if d.y < 0 {
            o.y = -o.y
            d.y = -d.y
            ry = true
        } else {
            ry = false
        }
        var pp: Double
        var ps, pd: Point
        if d.x > 0 {
            let dp = d.perpendicular
            let dd = d.dot(d)
            if d.y > 0 {
                var k = Point(x: -e.x, y: e.y)
                var dl = k - o
                var kd = dl.dot(dp)
                if kd >= 0 {
                    pp = dl.dot(d) / dd
                    ps = o + pp * d
                    pd = k
                } else {
                    k = Point(x: e.x, y: -e.y)
                    dl = k - o
                    kd = dl.dot(dp)
                    if kd <= 0 {
                        pp = dl.dot(d) / dd
                        ps = o + pp * d
                        pd = k
                    } else {
                        k = Point(x: e.x, y: e.y)
                        dl = k - o
                        kd = dl.dot(dp)
                        if kd >= 0 {
                            pp = (e.y - o.y) / d.y
                            ps = o + pp * d
                            pd = k
                        } else {
                            pp = (e.x - o.x) / d.x
                            ps = o + pp * d
                            pd = .init(
                                x: e.x,
                                y: o.y + pp * d.y
                            )
                        }
                        
                    }
                }
            } else {
                pp = (e.x - o.x) / d.x
                ps = o + pp * d
                pd = .init(
                    x: e.x,
                    y: o.y.clamp(-e.y, e.y)
                )
            }
        } else if d.y > 0 {
            pp = (e.y - o.y) / d.y
            ps = o + pp * d
            pd = .init(
                x: o.x.clamp(-e.x, e.x),
                y: e.y
            )
        } else {
            pp = 0
            ps = o
            pd = .init(
                x: o.x.clamp(-e.x, e.x),
                y: o.y.clamp(-e.y, e.y)
            )
        }
        if rx == true {
            ps.x = -ps.x
            pd.x = -pd.x
        }
        if ry == true {
            ps.y = -ps.y
            pd.y = -pd.y
        }
        ps += cf.center
        pd += cf.center
        return .init(
            line: .init(
                closest: .init(pp),
                point: ps
            ),
            box: pd
        )
    }
    
}

public extension Line2 {
    
    @inlinable
    func distance(_ other: AlignedBox2) -> Distance2.LineToAlignedBox {
        return Distance2.find(self, other)
    }
    
}
