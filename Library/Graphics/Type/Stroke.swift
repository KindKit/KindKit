//
//  KindKit
//

import KindMonadicMacro

@Monadic
public struct Stroke {
    
    @MonadicField
    public let width: Double
    
    @MonadicField
    public let join: LineJoin
    
    @MonadicField
    public let cap: LineCap
    
    @MonadicField
    public let dash: LineDash?
    
    @MonadicField
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

extension Stroke : Hashable {
}

extension Stroke : Equatable {
}

extension Stroke : Sendable {
}
