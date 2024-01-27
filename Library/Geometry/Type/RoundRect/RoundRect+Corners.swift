//
//  KindKit
//

import KindNumeric

extension RoundRect {
    
    public struct Corners : Hashable, Equatable {
        
        public var topLeft: Coordinate
        public var topRight: Coordinate
        public var bottomLeft: Coordinate
        public var bottomRight: Coordinate
        
        public init(
            topLeft: Coordinate,
            topRight: Coordinate,
            bottomLeft: Coordinate,
            bottomRight: Coordinate
        ) {
            self.topLeft = topLeft
            self.topRight = topRight
            self.bottomLeft = bottomLeft
            self.bottomRight = bottomRight
        }
        
    }
    
}
