//
//  KindKit
//

import Foundation

public extension Graphics {

    struct Stroke : Equatable {
        
        public let width: Double
        public let join: Graphics.LineJoin
        public let cap: Graphics.LineCap
        public let dash: Graphics.LineDash?
        public let fill: Graphics.Fill
        
        public init(
            width: Double,
            join: Graphics.LineJoin = .miter,
            cap: Graphics.LineCap = .butt,
            dash: Graphics.LineDash? = nil,
            fill: Graphics.Fill
        ) {
            self.width = width
            self.join = join
            self.cap = cap
            self.dash = dash
            self.fill = fill
        }
        
    }

}
