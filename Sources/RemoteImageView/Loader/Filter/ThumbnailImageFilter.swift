//
//  KindKitRemoteImageView
//

import Foundation
import KindKitCore
import KindKitMath
import KindKitView

public final class ThumbnailImageFilter : IRemoteImageFilter {

    public let size: SizeFloat
    public var name: String {
        return "\(self.size.width)x\(self.size.height)"
    }
    
    public init(_ size: SizeFloat) {
        self.size = size
    }
    
    public func apply(_ image: Image) -> Image? {
        return image.scaleTo(size: self.size)
    }
    
}
