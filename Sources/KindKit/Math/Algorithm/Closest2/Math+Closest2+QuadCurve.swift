//
//  KindKit
//

import Foundation

extension Math.Closest2 {
    
    public static func find(_ point: Point, _ curve: QuadCurve2) -> Percent {
        let c = curve - point
        let ds = c.control - c.start
        let de = c.end - c.control
        let p0 = 3 * (c.start * ds)
        let p1 = (c.start * de) + 2 * (c.control * ds)
        let p2 = (c.end * ds) + 2 * (c.control * de)
        let p3 = 3 * (c.end * de)
        let sl = c.start.squaredLength
        let el = c.end.squaredLength
        var ll = sl
        var r = Percent.zero
        if el < sl {
            ll = el
            r = .one
        }
        Bezier.droots(p0.x + p0.y, p1.x + p1.y, p2.x + p2.y, p3.x + p3.y, closure: { value in
            guard value > 0 && value < 1 else { return }
            let nr = Percent(value)
            let p = c.point(at: nr)
            let pl = p.squaredLength
            if pl < ll {
                ll = pl
                r = nr
            }
        })
        return r
    }
    
}

public extension QuadCurve2 {
    
    @inlinable
    func closest(_ point: Point) -> Percent {
        return Math.Closest2.find(point, self)
    }
    
}
