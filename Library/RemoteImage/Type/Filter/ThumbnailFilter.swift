//
//  KindKit
//

import KindGraphics
import KindGeometry

public final class ThumbnailFilter : Filter {
    
    public let size: Size
    public var name: String {
        return "\(self.size.width)x\(self.size.height)"
    }
    
    public init(_ size: Size) {
        self.size = size
    }
    
    public convenience init(
        _ size: Double
    ) {
        self.init(.init(
            width: size,
            height: size
        ))
    }
    
    public func apply(_ image: Image) -> Image? {
        return image.scaleTo(size: self.size)
    }
    
}
