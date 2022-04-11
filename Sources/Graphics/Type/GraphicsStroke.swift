//
//  KindKitGraphics
//

import Foundation
import KindKitView

public struct GraphicsStroke : Equatable {
    
    public let width: Float
    public let join: GraphicsLineJoin
    public let cap: GraphicsLineCap
    public let dash: GraphicsLineDash?
    public let fill: GraphicsFill
    
    public init(
        width: Float,
        join: GraphicsLineJoin = .miter,
        cap: GraphicsLineCap = .butt,
        dash: GraphicsLineDash? = nil,
        fill: GraphicsFill
    ) {
        self.width = width
        self.join = join
        self.cap = cap
        self.dash = dash
        self.fill = fill
    }
    
}
