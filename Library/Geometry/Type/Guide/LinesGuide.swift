//
//  KindKit
//

import KindNumeric
import KindMonadicMacro

@Monadic
public final class LinesGuide : Guide {
    
    public var isEnabled: Bool = true
    
    @MonadicField
    public var lines: [Line2]
    
    @MonadicField
    public var snap: Distance
    
    public init(
        lines: [Line2],
        snap: Distance
    ) {
        self.lines = lines
        self.snap = snap
    }
    
    public func guide(_ coordinate: Point) -> Point {
        guard self.isEnabled == true else { return coordinate }
        let lines: [Intermidiate] = self.lines.compactMap({
            let distance = $0.distance(coordinate)
            let absDistance = distance.abs
            guard absDistance <= self.snap else { return nil }
            return .init(line: $0, distance: $0.distance(coordinate))
        }).sorted(by: {
            $0.distance < $1.distance
        })
        if let i = lines.first {
            return i.line.perpendicular(coordinate)
        }
        return coordinate
    }

}

fileprivate extension LinesGuide {
    
    struct Intermidiate {
        
        let line: Line2
        let distance: Distance
        
    }
    
}
