//
//  KindKit
//

import KindNumeric

public struct CubicCurve2 : Hashable, Equatable {
    
    public var start: Point
    public var control1: Point
    public var control2: Point
    public var end: Point
    
    public init(
        start: Point,
        control1: Point,
        control2: Point,
        end: Point
    ) {
        self.start = start
        self.control1 = control1
        self.control2 = control2
        self.end = end
    }
    
}

public extension CubicCurve2 {
    
    var segment: ConvertCurve2< Segment2 > {
        let segment = Segment2(start: self.start, end: self.end)
        let d1 = self.control1 - segment.point(at: Percent(1.0 / 3.0))
        let d2 = self.control2 - segment.point(at: Percent(2.0 / 3.0))
        let dmx = (d1.x * d1.x).max(d2.x * d2.x)
        let dmy = (d1.y * d1.y).max(d2.y * d2.y)
        return .init(
            curve: segment,
            error: Distance(value: Percent(3.0 / 4.0) * (dmx + dmy).sqrt)
        )
    }
    
    var quadCurve: ConvertCurve2< QuadCurve2 > {
        let line = Segment2(start: self.start, end: self.end)
        let d1 = self.control1 - line.point(at: .init(1.0 / 3.0))
        let d2 = self.control2 - line.point(at: .init(2.0 / 3.0))
        let d = d1.halved() + d2.halved()
        let control = Percent(1.5) * d + line.point(at: .half)
        return .init(
            curve: .init(start: line.start, control: control, end: line.end),
            error: Percent(0.144334) * (d1 - d2).length
        )
    }
    
}

public extension CubicCurve2 {
    
    init(_ segment: Segment2) {
        self.start = segment.start
        self.control1 = (Percent(1.0 / 3.0) * segment.start) + (Percent(1.0 / 3.0) * segment.end)
        self.control2 = (Percent(2.0 / 3.0) * segment.start) + (Percent(2.0 / 3.0) * segment.end)
        self.end = segment.end
    }
    
    init(_ curve: QuadCurve2) {
        self.start = curve.start
        self.control1 = (Percent(1.0 / 3.0) * curve.control) + (Percent(1.0 / 3.0) * curve.end)
        self.control2 = (Percent(2.0 / 3.0) * curve.start) + (Percent(2.0 / 3.0) * curve.control)
        self.end = curve.end
    }
    
}
