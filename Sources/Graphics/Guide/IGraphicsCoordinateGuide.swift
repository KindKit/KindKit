//
//  KindKitGraphics
//

import Foundation
import KindKitCore
import KindKitMath

public protocol IGraphicsCoordinateGuide : IGraphicsGuide {
    
    func guide(_ coordinate: PointFloat) -> PointFloat?

}

public extension IGraphicsCoordinateGuide {
    
    func guide(_ segment: Segment2Float) -> Segment2Float? {
        let start = self.guide(segment.start)
        let end = self.guide(segment.end)
        if let start = start, let end = end {
            let ds = segment.start - start
            let ls = ds.length
            let de = segment.end - end
            let le = de.length
            let d = segment.end - segment.start
            if ls <= le {
                return Segment2(start: start, end: start + d)
            } else {
                return Segment2(start: end - d, end: end)
            }
        } else if let start = start {
            let d = segment.end - segment.start
            return Segment2(start: start, end: start + d)
        } else if let end = end {
            let d = segment.end - segment.start
            return Segment2(start: end - d, end: end)
        }
        return nil
    }
    
}
