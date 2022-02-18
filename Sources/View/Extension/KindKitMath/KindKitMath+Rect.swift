//
//  KindKitCore
//

import Foundation
import KindKitMath

public extension RectFloat {
    
    @inlinable
    func apply(width: DimensionBehaviour?, height: DimensionBehaviour?, aspectRatio: Float? = nil) -> RectFloat {
        return RectFloat(
            center: self.center,
            size: self.size.apply(width: width, height: height, aspectRatio: aspectRatio)
        )
    }
    
}
