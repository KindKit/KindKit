//
//  KindKit
//

import KindGraphics
import KindMonadicMacro

extension GradientView.Fill {
    
    @KindMonadic
    public struct Point : Equatable {
        
        @KindMonadicProperty
        public let color: Color
        
        @KindMonadicProperty
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
