//
//  KindKit
//

import KindGraphics

public extension GradientView.Fill {
    
    struct Point : Equatable {
        
        public let color: Color
        public let location: Double
        
        public init(
            color: Color,
            location: Double
        ) {
            self.color = color
            self.location = location
        }
        
    }
    
}
