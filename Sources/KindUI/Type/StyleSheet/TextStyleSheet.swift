//
//  KindKit
//

import KindEvent
import KindGraphics
import KindLayout
import KindMonadicMacro

@KindMonadic
public struct TextStyleSheet {
    
    @KindMonadicProperty
    public let style: Style?
    
    @KindMonadicProperty
    public let text: Text?
    
    @KindMonadicProperty
    public let numberOfLines: UInt?
    
    @KindMonadicProperty
    public let color: Color?
    
    @KindMonadicProperty
    public let alpha: Double?
    
    public init(
        style: Style? = nil,
        text: Text? = nil,
        numberOfLines: UInt? = nil,
        color: Color? = nil,
        alpha: Double? = nil
    ) {
        self.style = style
        self.text = text
        self.numberOfLines = numberOfLines
        self.color = color
        self.alpha = alpha
    }

}
