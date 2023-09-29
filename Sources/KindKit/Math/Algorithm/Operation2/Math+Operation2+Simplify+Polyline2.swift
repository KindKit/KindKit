//
//  KindKit
//

import Foundation

extension Math.Operation2.Simplify {
    
    public static func perform(
        polyline: Polyline2,
        distance: Distance
    ) -> Polyline2 {
        var corners = polyline.corners
        if corners.count > 1 && distance > .zero {
            let segs: [Segment2] = Array(unsafeUninitializedCapacity: corners.count, initializingWith: { buffer, count in
                for i in 0..<corners.count {
                    buffer[i] = Segment2(start: corners[i], end: corners[(i + 1) % corners.count])
                }
                count = corners.count
            })
            var cs: [Point] = []
            for i in 0 ..< segs.count {
                let s = segs[i]
                let sd = s.length
                if sd > distance {
                    cs.append(s.start)
                }
            }
            while let f = cs.first, let l = cs.last {
                let fld = f.distance(l)
                if fld > distance {
                    break
                }
                cs.remove(at: cs.endIndex - 1)
            }
            corners = cs
        }
        if corners.count > 1 {
            let segs: [Segment2] = Array(unsafeUninitializedCapacity: corners.count, initializingWith: { buffer, count in
                for i in 0..<corners.count {
                    buffer[i] = Segment2(start: corners[i], end: corners[(i + 1) % corners.count])
                }
                count = corners.count
            })
            let fs = segs[0]
            var cs = [ fs.start, fs.end ]
            var ln = fs.normal(at: .half)
            for i in 1 ..< segs.count {
                let s = segs[i]
                let n = s.normal(at: .half)
                if ln !~ n {
                    cs.append(s.end)
                    ln = n
                } else {
                    cs[cs.endIndex - 1] = s.end
                }
            }
            if cs.count > 1 {
                while cs.first! ~~ cs.last! {
                    cs.remove(at: cs.endIndex - 1)
                    if cs.isEmpty == true {
                        break
                    }
                }
            }
            while cs.count >= 4 {
                let ss = Segment2(start: cs[cs.startIndex], end: cs[cs.startIndex + 1])
                let es = Segment2(start: cs[cs.endIndex - 1], end: cs[cs.startIndex])
                let sn = ss.normal(at: .half)
                let en = es.normal(at: .half)
                if sn ~~ en {
                    cs.remove(at: cs.startIndex)
                } else {
                    break
                }
            }
            corners = cs
        }
        return Polyline2(corners: corners)
    }

}

public extension Polyline2 {
    
    func simplify(distance: Distance) -> Self {
        return Math.Operation2.Simplify.perform(polyline: self, distance: distance)
    }
    
}
