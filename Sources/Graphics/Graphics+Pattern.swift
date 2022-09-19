//
//  KindKit
//

import Foundation

public extension Graphics {

    struct Pattern : Equatable {
        
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

}
