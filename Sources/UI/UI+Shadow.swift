//
//  KindKit
//

import Foundation

public extension UI {
    
    struct Shadow : Equatable {

        public let color: Color
        public let opacity: Float
        public let radius: Float
        public let offset: PointFloat
        
        public init(
            color: Color,
            opacity: Float,
            radius: Float,
            offset: PointFloat
        ) {
            self.color = color
            self.opacity = opacity
            self.radius = radius
            self.offset = offset
        }

    }
    
}
