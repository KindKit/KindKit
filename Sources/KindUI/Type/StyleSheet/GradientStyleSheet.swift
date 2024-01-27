//
//  KindKit
//

import KindEvent
import KindGraphics
import KindLayout
import KindMonadicMacro

@KindMonadic
public struct GradientStyleSheet {
    
    @KindMonadicProperty
    public let fill: Gradient?
    
    @KindMonadicProperty
    public let color: Color?
    
    @KindMonadicProperty
    public let alpha: Double?
    
    public init(
        fill: Gradient? = nil,
        color: Color? = nil,
        alpha: Double? = nil
    ) {
        self.fill = fill
        self.color = color
        self.alpha = alpha
    }

}
