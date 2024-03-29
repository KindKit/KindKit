//
//  KindKit
//

import Foundation

extension Math.Closest2 {
    
    public static func find(_ point: Point, _ curve: CubicCurve2) -> Percent {
        let c = curve - point
        let q = QuadCurve2(start: curve.control1 - curve.start, control: curve.control2 - curve.control1, end: curve.end - curve.control2)
        let p0 = 10 * (c.start * q.start)
        let p1 = p0 + 4 * (c.start * (q.control - q.start)) + 6 * ((c.control1 - c.start) * q.start)
        let dd0t1 = 3 * ((c.control2 - 2 * c.control1 + c.start) * q.start)
        let dd0t2 = 6 * ((c.control1 - c.start) * (q.control - q.start))
        let dd0t3 = (c.start * (q.end - 2 * q.control + q.start))
        let dd0 = dd0t1 + dd0t2 + dd0t3
        let p2 = 2 * p1 - p0 + dd0
        let p5 = 10 * (c.end * q.end)
        let p4 = p5 - 4 * (c.end * (q.end - q.control)) - 6 * ((c.end - c.control2) * q.end)
        let dd1t1 = 3 * ((c.control1 - 2 * c.control2 + c.end) * q.end)
        let dd1t2 = 6 * ((c.end - c.control2) * (q.end - q.control))
        let dd1t3 = (c.end * (q.end - 2 * q.control + q.start))
        let dd1 = dd1t1 + dd1t2 + dd1t3
        let p3 = 2 * p4 - p5 + dd1
        let sl = c.start.squaredLength
        let el = c.end.squaredLength
        var ll = sl
        var r = Percent.zero
        if el < sl {
            ll = el
            r = .one
        }
        let polynomial = BernsteinPolynomial.Five(
            p0.x + p0.y,
            p1.x + p1.y,
            p2.x + p2.y,
            p3.x + p3.y,
            p4.x + p4.y,
            p5.x + p5.y
        )
        for value in BernsteinPolynomial.findDistinctRoots(of: polynomial) {
            guard value > 0.0, value < 1.0 else { break }
            let nr = Percent(value)
            let p = c.point(at: nr)
            let pl = p.squaredLength
            if pl < ll {
                ll = pl
                r = nr
            }
        }
        return r
    }
    
}

public extension CubicCurve2 {
    
    @inlinable
    func closest(_ point: Point) -> Percent {
        return Math.Closest2.find(point, self)
    }
    
}
