//
//  KindKit
//

import KindNumeric

public struct QuadCurve2 : Hashable, Equatable {
    
    public var start: Point
    public var control: Point
    public var end: Point
    
    public init(
        start: Point,
        control: Point,
        end: Point
    ) {
        self.start = start
        self.control = control
        self.end = end
    }
    
}

public extension QuadCurve2 {
    
    var segment: ConvertCurve2< Segment2 > {
        let segment = Segment2(start: self.start, end: self.end)
        return ConvertCurve2(
            curve: segment,
            error: (self.control - segment.point(at: .half)).length.halved()
        )
    }
    
}

public extension QuadCurve2 {
    
    init(_ segment: Segment2) {
        self.start = segment.start
        self.control = Percent.half * (segment.start + segment.end)
        self.end = segment.end
    }
    
}
