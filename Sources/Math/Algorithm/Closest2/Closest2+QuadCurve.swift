//
//  KindKitMath
//

import Foundation

public extension Closest2 {
    
    static func find(_ point: PointType, _ curve: QuadCurveType) -> Percent< ValueType > {
        let c = curve - point
        let ds = c.control - c.start
        let de = c.end - c.control
        let p0 = 3 * (c.start * ds)
        let p1 = (c.start * de) + 2 * (c.control * ds)
        let p2 = (c.end * ds) + 2 * (c.control * de)
        let p3 = 3 * (c.end * de)
        let sl = c.start.length.squared
        let el = c.end.length.squared
        var ll = sl
        var r: Percent< ValueType > = .zero
        if el < sl {
            ll = el
            r = .one
        }
        Bezier.droots((p0.x + p0.y).double, (p1.x + p1.y).double, (p2.x + p2.y).double, (p3.x + p3.y).double, closure: { value in
            guard value > 0 && value < 1 else { return }
            let nr = Percent(ValueType(value))
            let p = c.point(at: nr)
            let pl = p.length.squared
            if pl < ll {
                ll = pl
                r = nr
            }
        })
        return r
    }
    
}
