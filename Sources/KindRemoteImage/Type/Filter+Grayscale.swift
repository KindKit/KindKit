//
//  KindKit
//

import KindGraphics

public extension Filter {
    
    final class Grayscale : IFilter {

        public var name: String {
            return "grayscale"
        }
        
        public init() {
        }
        
        public func apply(_ image: Image) -> Image? {
            return image.grayscale
        }
        
    }
    
}
