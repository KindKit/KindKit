//
//  KindKit
//

import KindGeometry
import KindMonadicMacro

@Monadic
public struct Pattern {

    @MonadicField
    public let image: Image
    
    @MonadicField
    public let step: Point
    
    public init(
        image: Image,
        step: Point? = nil
    ) {
        self.image = image
        self.step = step ?? Point(image.size)
    }
    
}

extension Pattern : Hashable {
}

extension Pattern : Equatable {
}

extension Pattern : Sendable {
}
