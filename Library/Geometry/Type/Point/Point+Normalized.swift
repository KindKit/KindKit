//
//  KindKit
//

import KindNumeric

extension Point {
    
    public struct Normalized {
        
        public let point: Point
        public let length: SquaredDistance
        
        public init(
            point: Point,
            length: SquaredDistance
        ) {
            self.point = point
            self.length = length
        }
        
    }
    
}
