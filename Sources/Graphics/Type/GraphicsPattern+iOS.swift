//
//  KindKitGraphics
//

#if os(iOS)

import UIKit
import CoreGraphics
import KindKitCore
import KindKitMath
import KindKitView

public extension GraphicsPattern {
    
    var cgPattern: CGPattern? {
        var callbacks = CGPatternCallbacks(version: 0, drawPattern: { info, context in
            guard let info = info else { return }
            let image = Unmanaged< UIImage >.fromOpaque(info).takeUnretainedValue()
            if let cgImage = image.cgImage {
                context.scaleBy(x: 1, y: -1)
                context.translateBy(x: 0, y: CGFloat(-image.size.height))
                context.draw(cgImage, in: CGRect(origin: .zero, size: image.size))
            }
        }, releaseInfo: nil)
        return CGPattern(
            info: Unmanaged.passRetained(self.image.native).toOpaque(),
            bounds: CGRect(origin: .zero, size: self.image.size.cgSize),
            matrix: .identity,
            xStep: CGFloat(self.step.x),
            yStep: CGFloat(self.step.y),
            tiling: .constantSpacing,
            isColored: true,
            callbacks: &callbacks
        )
    }
    
}

#endif
