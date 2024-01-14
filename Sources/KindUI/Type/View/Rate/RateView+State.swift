//
//  KindKit
//

#if os(iOS)

import KindGraphics

extension RateView {
    
    public struct State : Equatable {
        
        public let image: Image
        public let rate: Double
        
        public init(
            image: Image,
            rate: Double
        ) {
            self.image = image
            self.rate = rate
        }
        
    }
    
}

#endif
