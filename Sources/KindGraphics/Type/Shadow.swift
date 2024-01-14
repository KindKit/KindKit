//
//  KindKit
//

import KindMath

public struct Shadow : Equatable {
    
    public let color: Color
    public let opacity: Double
    public let radius: Double
    public let offset: Point
    
    public init(
        color: Color,
        opacity: Double,
        radius: Double,
        offset: Point
    ) {
        self.color = color
        self.opacity = opacity
        self.radius = radius
        self.offset = offset
    }

}
