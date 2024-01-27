//
//  KindKit
//

import KindEvent
import KindGraphics
import KindLayout
import KindMonadicMacro

@KindMonadic
public struct RectStyleSheet {
    
    @KindMonadicProperty
    public let border: Border?
    
    @KindMonadicProperty
    public let cornerRadius: CornerRadius?
    
    @KindMonadicProperty
    public let fill: Color?
    
    @KindMonadicProperty
    public let color: Color?
    
    @KindMonadicProperty
    public let alpha: Double?
    
    public init(
        border: Border? = nil,
        cornerRadius: CornerRadius? = nil,
        fill: Color? = nil,
        color: Color? = nil,
        alpha: Double? = nil
    ) {
        self.border = border
        self.cornerRadius = cornerRadius
        self.fill = fill
        self.color = color
        self.alpha = alpha
    }

}
