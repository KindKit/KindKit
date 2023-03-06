//
//  KindKit
//

import Foundation

public extension UI.Dialog {
    
    struct Size : Equatable {
        
        public var width: Dimension
        public var height: Dimension
        
        public init(
            _ width: Dimension,
            _ height: Dimension
        ) {
            self.width = width
            self.height = height
        }
        
    }
    
}
