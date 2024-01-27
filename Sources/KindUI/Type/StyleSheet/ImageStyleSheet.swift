//
//  KindKit
//

import KindEvent
import KindGraphics
import KindLayout
import KindMonadicMacro

@KindMonadic
public struct ImageStyleSheet {
    
    @KindMonadicProperty
    public let image: Image?
    
    @KindMonadicProperty
    public let mode: ImageMode?
    
    @KindMonadicProperty
    public let tintColor: Color?
    
    @KindMonadicProperty
    public let color: Color?
    
    @KindMonadicProperty
    public let alpha: Double?
    
    public init(
        image: Image? = nil,
        mode: ImageMode? = nil,
        tintColor: Color? = nil,
        color: Color? = nil,
        alpha: Double? = nil
    ) {
        self.image = image
        self.mode = mode
        self.tintColor = tintColor
        self.color = color
        self.alpha = alpha
    }

}
