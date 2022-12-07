//
//  KindKit
//

import Foundation

public extension UI.Layout.Composition.VAccessory {
    
    struct Info {
        
        public var entity: IUICompositionLayoutEntity
        public var spacing: Double
        public var priority: UInt
        
        public init(
            entity: IUICompositionLayoutEntity,
            spacing: Double,
            priority: UInt = 0
        ) {
            self.entity = entity
            self.spacing = spacing
            self.priority = priority
        }
        
    }
    
}
