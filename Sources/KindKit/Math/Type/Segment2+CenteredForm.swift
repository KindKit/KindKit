//
//  KindKit
//

import Foundation

public extension Segment2 {
    
    public struct CenteredForm : Hashable {
        
        public var center: Point
        public var direction: Point
        public var extend: Double
        
        public init(
            center: Point,
            direction: Point,
            extend: Double
        ) {
            self.center = center
            self.direction = direction
            self.extend = extend
        }
        
    }
    
}
