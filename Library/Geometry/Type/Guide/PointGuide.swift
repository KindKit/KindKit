//
//  KindKit
//

import KindNumeric
import KindMonadicMacro

@Monadic
public final class PointGuide : Guide {
    
    public var isEnabled: Bool = true
    
    @MonadicField
    public var points: [Point]
    
    @MonadicField
    public var snap: Distance
    
    public init(
        points: [Point],
        snap: Distance
    ) {
        self.points = points
        self.snap = snap
    }
    
    public func guide(_ coordinate: Point) -> Point {
        guard self.isEnabled == true else { return coordinate }
        let oi = self.points.map({ ($0, $0.length(coordinate)) })
        let fi = oi.filter({ $0.1.abs <= self.snap })
        let si = fi.sorted(by: { $0.1 < $1.1 })
        if let i = si.first {
            return i.0
        }
        return coordinate
    }

}
