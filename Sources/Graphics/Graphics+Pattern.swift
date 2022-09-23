//
//  KindKit
//

import Foundation

public extension Graphics {

    struct Pattern : Equatable {
        
        public let image: UI.Image
        public let step: PointFloat
        
        public init(
            image: UI.Image,
            step: PointFloat? = nil
        ) {
            self.image = image
            self.step = step ?? Point(x: image.size.width, y: image.size.height)
        }
        
    }

}
