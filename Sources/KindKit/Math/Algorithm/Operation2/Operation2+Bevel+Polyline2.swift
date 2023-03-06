//
//  KindKit
//

import Foundation

public extension Operation2.Bevel {
    
    static func perform(
        polyline: Polyline2,
        index: CornerIndex,
        distance: Double
    ) -> Polyline2 {
        guard polyline.isValid(index) == true else { return polyline }
        guard polyline.corners.count > 2 else { return polyline }
        guard let es = polyline[edges: index] else { return polyline }
        guard distance !~ 0 else { return polyline }
        var cs = polyline.corners
        do {
            let ls = polyline[segment: es.left]
            let lsl = ls.length.real
            let rs = polyline[segment: es.right]
            let rsl = rs.length.real
            let ml = min(lsl, rsl)
            let nd = min(ml, distance)
            if ml > nd {
                let i = min(index.value + 1, cs.endIndex)
                let sls = ls.split(at: Percent(1 - (nd / lsl)))
                let srs = rs.split(at: Percent(nd / rsl))
                cs[index.value] = sls.left.end
                cs.insert(srs.right.start, at: i)
            } else if lsl > nd {
                let ss = ls.split(at: Percent(1 - (nd / lsl)))
                cs[index.value] = ss.left.end
            } else if rsl > nd {
                let ss = rs.split(at: Percent(nd / rsl))
                cs[index.value] = ss.right.start
            } else {
                cs.remove(at: index.value)
            }
        }
        return Polyline2(corners: cs)
    }

}

public extension Polyline2 {
    
    func bevel(index: CornerIndex, distance: Double) -> Self {
        return Operation2.Bevel.perform(polyline: self, index: index, distance: distance)
    }
    
}
