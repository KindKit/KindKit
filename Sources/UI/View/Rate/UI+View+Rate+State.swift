//
//  KindKit
//

#if os(iOS)

import Foundation

public extension UI.View.Rate {
    
    struct State : Equatable {
        
        public let image: UI.Image
        public let rate: Double
        
        public init(
            image: UI.Image,
            rate: Double
        ) {
            self.image = image
            self.rate = rate
        }
        
    }
    
}

#endif
