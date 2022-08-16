//
//  KindKitCore
//

#if os(iOS)

import UIKit
import CoreImage

public extension CIImage {
    
    func cgImage(withScale scale: CGPoint) -> CGImage? {
        guard let cgImage = CIContext(options: nil).createCGImage(self, from: self.extent) else {
            return nil
        }
        guard let cgColorSpace = cgImage.colorSpace else {
            return nil
        }
        let size = CGSize(
            width: self.extent.size.width * scale.x,
            height: self.extent.size.height * scale.y
        )
        guard let context = CGContext(
            data: nil,
            width: Int(size.width),
            height: Int(size.height),
            bitsPerComponent: 8,
            bytesPerRow: 0,
            space: cgColorSpace,
            bitmapInfo: cgImage.bitmapInfo.rawValue
        ) else {
            return nil
        }
        context.interpolationQuality = .none
        context.translateBy(x: 0, y: size.height)
        context.scaleBy(x: 1.0, y: -1.0)
        context.draw(cgImage, in: context.boundingBoxOfClipPath)
        return context.makeImage()
    }
    
}

#endif
