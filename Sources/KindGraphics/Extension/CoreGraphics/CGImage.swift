//
//  KindKit
//

#if canImport(CoreGraphics)

import CoreGraphics

public extension CGImage {
    
    func kk_compare(
        expected: CGImage,
        tolerance: CGFloat
    ) -> Bool {
        guard let originColorSpace = self.colorSpace, let expectedColorSpace = expected.colorSpace else {
            return false
        }
        if expected.width != self.width || expected.height != self.height || expected.bitsPerComponent != self.bitsPerComponent {
            return false
        }
        let imageSize = CGSize(width: expected.width, height: expected.height)
        let numberOfPixels = Int(imageSize.width * imageSize.height)
        let bitsPerComponent = self.bitsPerComponent
        let bytesPerRow = min(expected.bytesPerRow, self.bytesPerRow)
        assert(MemoryLayout< UInt32 >.stride == bytesPerRow / Int(imageSize.width))
        let originPixels = UnsafeMutablePointer< UInt32 >.allocate(capacity: numberOfPixels)
        let expectedPixels = UnsafeMutablePointer< UInt32 >.allocate(capacity: numberOfPixels)
        let originPixelsRaw = UnsafeMutableRawPointer(originPixels)
        let expectedPixelsRaw = UnsafeMutableRawPointer(expectedPixels)
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        guard let expectedContext = CGContext(data: expectedPixelsRaw, width: Int(imageSize.width), height: Int(imageSize.height), bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: expectedColorSpace, bitmapInfo: bitmapInfo.rawValue) else {
            expectedPixels.deallocate()
            originPixels.deallocate()
            return false
        }
        guard let originContext = CGContext(data: originPixelsRaw, width: Int(imageSize.width), height: Int(imageSize.height), bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: originColorSpace, bitmapInfo: bitmapInfo.rawValue) else {
            expectedPixels.deallocate()
            originPixels.deallocate()
            return false
        }
        expectedContext.draw(expected, in: CGRect(origin: .zero, size: imageSize))
        originContext.draw(self, in: CGRect(origin: .zero, size: imageSize))
        let expectedBuffer = UnsafeBufferPointer(start: expectedPixels, count: numberOfPixels)
        let originBuffer = UnsafeBufferPointer(start: originPixels, count: numberOfPixels)
        var isEqual = true
        if tolerance == 0 {
            isEqual = expectedBuffer.elementsEqual(originBuffer)
        } else {
            var numDiffPixels = 0
            for pixel in 0 ..< numberOfPixels where expectedBuffer[pixel] != originBuffer[pixel] {
                numDiffPixels += 1
                let percentage = 100 * CGFloat(numDiffPixels) / CGFloat(numberOfPixels)
                if percentage > tolerance {
                    isEqual = false
                    break
                }
            }
        }
        expectedPixels.deallocate()
        originPixels.deallocate()
        return isEqual
    }
    
}

#endif
