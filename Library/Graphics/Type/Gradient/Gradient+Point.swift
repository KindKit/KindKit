//
//  KindKit
//

import KindMonadicMacro

extension Gradient {
    
    @Monadic
    public struct Point {
        
        @MonadicField
        public let color: Color
        
        @MonadicField
        public let location: Coordinate
        
        public init(
            color: Color,
            location: Coordinate
        ) {
            self.color = color
            self.location = location
        }
        
    }
    
}

extension Gradient.Point : Hashable {
}

extension Gradient.Point : Equatable {
}

extension Gradient.Point : Sendable {
}
