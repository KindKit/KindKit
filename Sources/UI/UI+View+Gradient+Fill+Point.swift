//
//  KindKit
//

import Foundation

public extension UI.View.Gradient.Fill {
    
    struct Point : Equatable {
        
        public let color: UI.Color
        public let location: Float
        
        public init(
            color: UI.Color,
            location: Float
        ) {
            self.color = color
            self.location = location
        }
        
    }
    
}
