//
//  KindKit
//

import KindNumeric

extension Operation2.Extrude {
    
    public static func perform(
        polyline: Polyline2,
        index: Polyline2.EdgeIndex,
        left: Distance,
        right: Distance,
        distance: Distance
    ) -> Polyline2 {
        guard polyline.isValid(index) == true else { return polyline }
        guard distance.isNotNearZero else { return polyline }
        let es = polyline[edges: index]
        var cs = polyline.corners
        do {
            let e = polyline[edge: index]
            let s = polyline[segment: index]
            let sl = s.length
            let ll = min(left, right)
            let rl = max(left, right)
            let lp = max(Percent(ll.value, from: sl.value), .min)
            let rp = min(Percent(rl.value, from: sl.value), .max)
            let i = min(e.start.value + 1, cs.endIndex)
            let ci1 = s.point(at: lp)
            let ci2 = s.offset(at: lp, distance: distance)
            let ci3 = s.offset(at: rp, distance: distance)
            let ci4 = s.point(at: rp)
            if lp.isNearMin {
                let os1 = polyline[segment: es.left]
                let on1 = os1.normal(at: .half)
                let os2 = Segment2(start: ci1, end: ci2)
                let on2 = os2.normal(at: .half)
                if on1.isNearEqual(on2) || on1.isNearEqual(-on2) {
                    cs[es.left.end.value] = ci2
                    cs.insert(contentsOf: [ ci3, ci4 ], at: i)
                } else {
                    cs.insert(contentsOf: [ ci2, ci3, ci4 ], at: i)
                }
            } else if rp.isNearMax {
                let os1 = polyline[segment: es.right]
                let on1 = os1.normal(at: .half)
                let os2 = Segment2(start: ci3, end: ci4)
                let on2 = os2.normal(at: .half)
                if on1.isNearEqual(on2) || on1.isNearEqual(-on2) {
                    cs[es.right.start.value] = ci3
                    cs.insert(contentsOf: [ ci1, ci2 ], at: i)
                } else {
                    cs.insert(contentsOf: [ ci1, ci2, ci3 ], at: i)
                }
            } else {
                cs.insert(contentsOf: [ ci1, ci2, ci3, ci4 ], at: i)
            }
        }
        return Polyline2(cs)
    }

}

public extension Polyline2 {
    
    func extrude(index: EdgeIndex, left: Distance, right: Distance, distance: Distance) -> Self {
        return Operation2.Extrude.perform(polyline: self, index: index, left: left, right: right, distance: distance)
    }
    
}
