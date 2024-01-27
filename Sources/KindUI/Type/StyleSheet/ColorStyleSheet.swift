//
//  KindKit
//

import KindEvent
import KindGraphics
import KindLayout
import KindMonadicMacro

@KindMonadic
public struct ColorStyleSheet {
    
    @KindMonadicProperty
    public let color: Color?
    
    @KindMonadicProperty
    public let alpha: Double?
    
    public init(
        color: Color? = nil,
        alpha: Double? = nil
    ) {
        self.color = color
        self.alpha = alpha
    }

}
