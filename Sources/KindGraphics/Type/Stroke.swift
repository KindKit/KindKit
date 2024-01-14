//
//  KindKit
//

import Foundation

public struct Stroke : Equatable {
    
    public let width: Double
    public let join: LineJoin
    public let cap: LineCap
    public let dash: LineDash?
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
