//
//  KindKit
//

import Foundation

#if os(macOS)
#warning("Require support macOS")
#elseif os(iOS)

public extension UI.View.Shape {
    
    struct Line : Equatable {
        
        public let width: Double
        public let cap: Graphics.LineCap
        public let join: Graphics.LineJoin
        public let dash: Graphics.LineDash?
        
        public init(
            width: Double = 1,
            cap: Graphics.LineCap = .butt,
            join: Graphics.LineJoin = .miter(10),
            dash: Graphics.LineDash? = nil
        ) {
            self.width = width
            self.cap = cap
            self.join = join
            self.dash = dash
        }
        
    }
    
}

extension UI.View.Shape.Line : ILerpable {
    
    public func lerp(_ to: Self, progress: Percent) -> Self {
        return .init(
            width: self.width.lerp(to.width, progress: progress),
            cap: self.cap,
            join: self.join,
            dash: self.dash
        )
    }
    
}

#endif
