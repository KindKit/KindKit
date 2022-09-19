//
//  KindKit
//

#if os(iOS)

import Foundation

public extension UI.View.Rate {
    
    struct State {
        
        public let image: Image
        public let rate: Float
        
        public init(
            image: Image,
            rate: Float
        ) {
            self.image = image
            self.rate = rate
        }
        
    }
    
}

#endif
