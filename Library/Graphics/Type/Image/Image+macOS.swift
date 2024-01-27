//
//  KindKit
//


#if os(macOS)

import AppKit
import ImageIO
import KindGeometry
import KindNumeric

public typealias NativeImage = NSImage

public extension Image {
    
    init(
        name: String,
        in bundle: Bundle? = nil
    ) {
        if let bundle = bundle {
            guard let image = bundle.image(forResource: name) else {
                fatalError("Not found image with '\(name)'")
            }
            self.init(image)
        } else {
            guard let image = NSImage(named: name) else {
                fatalError("Not found image with '\(name)'")
            }
            self.init(image)
        }
    }
    
    init?(
        data: Data
    ) {
        guard let image = NSImage(data: data) else { return nil }
        self.handle = image
        self.size = Size(image.size)
        self.scale = 1
    }
    
    init?(
        url: URL
    ) {
        guard let image = NSImage(contentsOf: url) else { return nil }
        self.handle = image
        self.size = Size(image.size)
        self.scale = 1
    }
    
    init(
        _ handle: NSImage
    ) {
        self.handle = handle
        self.size = Size(handle.size)
        self.scale = 1
    }
    
    init(
        _ cgImage: CGImage
    ) {
        self.handle = NSImage(cgImage: cgImage, size: .zero)
        self.size = Size(self.handle.size)
        self.scale = 1
    }
    
}

public extension Image {
    
    var cgImage: CGImage? {
        return self.handle.cgImage(forProposedRect: nil, context: nil, hints: nil)
    }
    
    var grayscale: Image? {
        let context = CIContext(options: nil)
        guard let cgImage = self.cgImage else {
            return nil
        }
        guard let filter = CIFilter(name: "CIPhotoEffectNoir") else {
            return nil
        }
        filter.setValue(CIImage(cgImage: cgImage), forKey: kCIInputImageKey)
        if let output = filter.outputImage, let outputCgImage = context.createCGImage(output, from: output.extent) {
            return .init(outputCgImage)
        }
        return nil
    }
    
}

public extension Image {
    
    func compare(
        expected: Image,
        tolerance: Percent
    ) -> Bool {
        guard let origin = self.cgImage, let expected = expected.cgImage else { return false }
        return origin.kk_compare(expected: expected, tolerance: tolerance.value.cgFloat)
    }
    
    func pngData() -> Data? {
        guard let data = self.handle.tiffRepresentation else { return nil }
        guard let representation = NSBitmapImageRep(data: data) else { return nil }
        return representation.representation(using: .png, properties: [:])
    }
    
    func scaleTo(size: Size) -> Image? {
        let targetSize = self.size.aspectFit(size).cgSize
        let rect = NSRect(origin: .zero, size: targetSize)
        guard let representation = self.handle.bestRepresentation(for: rect, context: nil, hints: nil) else {
            return nil
        }
        return .init(NSImage(
            size: targetSize,
            flipped: false,
            drawingHandler: { _ in representation.draw(in: rect) }
        ))
    }
    
}

#endif
