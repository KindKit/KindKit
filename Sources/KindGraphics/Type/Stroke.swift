//
//  KindKit
//

import KindMonadicMacro

@KindMonadic
public struct Stroke : Equatable {
    
    @KindMonadicProperty
    public let width: Double
    
    @KindMonadicProperty
    public let join: LineJoin
    
    @KindMonadicProperty
    public let cap: LineCap
    
    @KindMonadicProperty
    public let dash: LineDash?
    
    @KindMonadicProperty
    public let fill: Fill
    
    public init(
        width: Double,
        join: LineJoin = .miter(10),
        cap: LineCap = .butt,
        dash: LineDash? = nil,
        fill: Fill
    ) {
        self.width = width
        self.join = join
        self.cap = cap
        self.dash = dash
        self.fill = fill
    }
    
}
