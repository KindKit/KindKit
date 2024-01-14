//
//  KindKit
//

import KindMath

public struct Pattern : Equatable {
    
    public let image: Image
    public let step: Point
    
    public init(
        image: Image,
        step: Point? = nil
    ) {
        self.image = image
        self.step = step ?? Point(x: image.size.width, y: image.size.height)
    }
    
}
