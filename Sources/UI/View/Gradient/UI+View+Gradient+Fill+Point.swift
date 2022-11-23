//
//  KindKit
//

import Foundation

public extension UI.View.Gradient.Fill {
    
    struct Point : Equatable {
        
        public let color: UI.Color
        public let location: Double
        
        public init(
            color: UI.Color,
            location: Double
        ) {
            self.color = color
            self.location = location
        }
        
    }
    
}
