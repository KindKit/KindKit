//
//  KindKit
//

import KindGeometry
import KindMonadicMacro

@Monadic
public struct Shadow {
    
    public typealias Opacity = Coordinate
    public typealias Radius = Coordinate
    public typealias Offset = KindGraphics.Point
    
    @MonadicField
    public let color: Color
    
    @MonadicField
    public let opacity: Opacity
    
    @MonadicField
    public let radius: Radius
    
    @MonadicField
    public let offset: Offset
    
    public init(
        color: Color,
        opacity: Opacity,
        radius: Radius,
        offset: Offset
    ) {
        self.color = color
        self.opacity = opacity
        self.radius = radius
        self.offset = offset
    }

}

extension Shadow : Hashable {
}

extension Shadow : Equatable {
}

extension Shadow : Sendable {
}
