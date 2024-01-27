//
//  KindKit
//

extension AlignedBox2 {
    
    public struct CenteredForm {
        
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
