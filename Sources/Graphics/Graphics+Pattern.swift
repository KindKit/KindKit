//
//  KindKit
//

import Foundation

public extension Graphics {

    struct Pattern : Equatable {
        
        public let image: UI.Image
        public let step: Point
        
        public init(
            image: UI.Image,
            step: Point? = nil
        ) {
            self.image = image
            self.step = step ?? Point(x: image.size.width, y: image.size.height)
        }
        
    }

}
