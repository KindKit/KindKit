//
//  KindKitCore
//

import Foundation
import KindKitMath

public extension SizeFloat {
    
    @inlinable
    func apply(width: DimensionBehaviour?, height: DimensionBehaviour?, aspectRatio: Float? = nil) -> SizeFloat {
        if let aspectRatio = aspectRatio {
            if let width = width?.value(self.width) {
                return SizeFloat(
                    width: width,
                    height: width / aspectRatio
                )
            } else if let height = height?.value(self.height) {
                return SizeFloat(
                    width: height * aspectRatio,
                    height: height
                )
            }
        }
        return SizeFloat(
            width: width?.value(self.width) ?? 0,
            height: height?.value(self.height) ?? 0
        )
    }
    
}
