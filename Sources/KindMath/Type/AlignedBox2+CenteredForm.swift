//
//  KindKit
//

import Foundation

public extension AlignedBox2 {
    
    struct CenteredForm : Hashable {
        
        public var center: Point
        public var extent: Point
        
        public init(
            center: Point,
            extent: Point
        ) {
            self.center = center
            self.extent = extent
        }
        
    }
    
}
