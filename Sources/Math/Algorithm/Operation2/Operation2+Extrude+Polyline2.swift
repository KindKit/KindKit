//
//  KindKit
//

import Foundation

public extension Operation2.Extrude {
    
    static func perform(
        polyline: Polyline2,
        index: EdgeIndex,
        left: Double,
        right: Double,
        distance: Double
    ) -> Polyline2 {
        guard polyline.isValid(index) == true else { return polyline }
        guard let es = polyline[edges: index] else { return polyline }
        guard distance !~ 0 else { return polyline }
        var cs = polyline.corners
        do {
            let e = polyline[edge: index]
            let s = polyline[segment: index]
            let sl = s.length.real
            let ll = min(left, right)
            let rl = max(left, right)
            let lp = max(ll / sl, 0)
            let rp = min(rl / sl, 1)
            let i = min(e.start.value + 1, cs.endIndex)
            let ci1 = s.point(at: Percent(lp))
            let ci2 = s.offset(at: Percent(lp), distance: distance)
            let ci3 = s.offset(at: Percent(rp), distance: distance)
            let ci4 = s.point(at: Percent(rp))
            if lp ~~ 0 {
                let os1 = polyline[segment: es.left]
                let on1 = os1.normal(at: .half)
                let os2 = Segment2(start: ci1, end: ci2)
                let on2 = os2.normal(at: .half)
                if on1 ~~ on2 || on1 ~~ -on2 {
                    cs[es.left.end.value] = ci2
                    cs.insert(contentsOf: [ ci3, ci4 ], at: i)
                } else {
                    cs.insert(contentsOf: [ ci2, ci3, ci4 ], at: i)
                }
            } else if rp ~~ 1 {
                let os1 = polyline[segment: es.right]
                let on1 = os1.normal(at: .half)
                let os2 = Segment2(start: ci3, end: ci4)
                let on2 = os2.normal(at: .half)
                if on1 ~~ on2 || on1 ~~ -on2 {
                    cs[es.right.start.value] = ci3
                    cs.insert(contentsOf: [ ci1, ci2 ], at: i)
                } else {
                    cs.insert(contentsOf: [ ci1, ci2, ci3 ], at: i)
                }
            } else {
                cs.insert(contentsOf: [ ci1, ci2, ci3, ci4 ], at: i)
            }
        }
        return Polyline2(corners: cs)
    }

}

public extension Polyline2 {
    
    func extrude(index: EdgeIndex, left: Double, right: Double, distance: Double) -> Self {
        return Operation2.Extrude.perform(polyline: self, index: index, left: left, right: right, distance: distance)
    }
    
}
