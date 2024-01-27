//
//  KindKit
//

import KindMath
import KindMonadicMacro

@KindMonadic
public struct Shadow : Equatable {
    
    @KindMonadicProperty
    public let color: Color
    
    @KindMonadicProperty
    public let opacity: Double
    
    @KindMonadicProperty
    public let radius: Double
    
    @KindMonadicProperty
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
