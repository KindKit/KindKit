//
//  KindKitGraphics
//

import Foundation
import KindKitView
import KindKitMath

public struct GraphicsPattern : Equatable {
    
    public let image: Image
    public let step: PointFloat
    
    public init(
        image: Image,
        step: PointFloat? = nil
    ) {
        self.image = image
        self.step = step ?? Point(x: image.size.width, y: image.size.height)
    }
    
}
