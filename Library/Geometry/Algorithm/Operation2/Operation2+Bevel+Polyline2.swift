//
//  KindKit
//

import KindNumeric

extension Operation2.Bevel {
    
    public static func perform(
        polyline: Polyline2,
        index: Polyline2.CornerIndex,
        distance: Distance
    ) -> Polyline2 {
        guard polyline.isValid(index) == true else { return polyline }
        guard polyline.corners.count > 2 else { return polyline }
        guard distance.isNotNearZero else { return polyline }
        let es = polyline[edges: index]
        var cs = polyline.corners
        do {
            let ls = polyline[segment: es.left]
            let lsl = ls.length
            let rs = polyline[segment: es.right]
            let rsl = rs.length
            let ml = min(lsl, rsl)
            let nd = min(ml, distance)
            if ml > nd {
                let i = min(index.value + 1, cs.endIndex)
                let sls = ls.split(at: Percent(nd.value, from: lsl.value).invert)
                let srs = rs.split(at: Percent(nd.value, from: rsl.value))
                cs[index.value] = sls.left.end
                cs.insert(srs.right.start, at: i)
            } else if lsl > nd {
                let ss = ls.split(at: Percent(nd.value, from: lsl.value).invert)
                cs[index.value] = ss.left.end
            } else if rsl > nd {
                let ss = rs.split(at: Percent(nd.value, from: rsl.value))
                cs[index.value] = ss.right.start
            } else {
                cs.remove(at: index.value)
            }
        }
        return Polyline2(cs)
    }

}

public extension Polyline2 {
    
    func bevel(index: CornerIndex, distance: Distance) -> Self {
        return Operation2.Bevel.perform(polyline: self, index: index, distance: distance)
    }
    
}
