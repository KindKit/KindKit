//
//  KindKit
//

import Foundation

public protocol IGraphicsCoordinateGuide : IGraphicsGuide {
    
    func guide(_ coordinate: Point) -> Point?

}

public extension IGraphicsCoordinateGuide {
    
    func guide(_ segment: Segment2) -> Segment2? {
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
