//
//  KindKit
//

import KindMath
import KindMonadicMacro

@KindMonadic
public struct Pattern : Equatable {

    @KindMonadicProperty
    public let image: Image
    
    @KindMonadicProperty
    public let step: Point
    
    public init(
        image: Image,
        step: Point? = nil
    ) {
        self.image = image
        self.step = step ?? Point(x: image.size.width, y: image.size.height)
    }
    
}
