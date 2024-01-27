//
//  KindKit
//

import KindGraphics

public final class GrayscaleFilter : Filter {
    
    public var name: String {
        return "grayscale"
    }
    
    public init() {
    }
    
    public func apply(_ image: Image) -> Image? {
        return image.grayscale
    }
    
}
