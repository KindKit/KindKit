//
//  KindKit
//

extension CompositionLayout.VAccessoryPart {
    
    public struct Info {
        
        public var item: ILayoutPart
        public var spacing: Double
        public var priority: UInt
        
        public init(
            item: ILayoutPart,
            spacing: Double,
            priority: UInt = 0
        ) {
            self.item = item
            self.spacing = spacing
            self.priority = priority
        }
        
    }
    
}
