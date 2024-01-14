//
//  KindKit
//

import Foundation

extension Segment2 {
    
    public struct CenteredForm : Hashable {
        
        public var center: Point
        public var direction: Point
        public var extend: Distance
        
        public init(
            center: Point,
            direction: Point,
            extend: Distance
        ) {
            self.center = center
            self.direction = direction
            self.extend = extend
        }
        
    }
    
}
