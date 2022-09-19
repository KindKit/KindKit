//
//  KindKit
//


#if os(macOS)

import AppKit
import ImageIO

public struct Image : Equatable {

    public var native: NSImage
    public var size: SizeFloat
    public var scale: Float {
        return 1
    }
    
    public init(
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
    
    public init?(
        data: Data
    ) {
        guard let image = NSImage(data: data) else { return nil }
        self.native = image
        self.size = SizeFloat(image.size)
    }
    
    public init?(
        url: URL
    ) {
        guard let image = NSImage(contentsOf: url) else { return nil }
        self.native = image
        self.size = SizeFloat(image.size)
    }
    
    public init(
        _ native: NSImage
    ) {
        self.native = native
        self.size = SizeFloat(native.size)
    }
    
    public init(
        _ cgImage: CGImage
    ) {
        self.native = NSImage(cgImage: cgImage, size: .zero)
        self.size = SizeFloat(self.native.size)
    }
    
}

public extension Image {
    
    var cgImage: CGImage? {
        return self.native.cgImage(forProposedRect: nil, context: nil, hints: nil)
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
            return Image(outputCgImage)
        }
        return nil
    }
    
}

public extension Image {
    
    func pngData() -> Data? {
        guard let data = self.native.tiffRepresentation else { return nil }
        guard let representation = NSBitmapImageRep(data: data) else { return nil }
        return representation.representation(using: .png, properties: [:])
    }
    
    func scaleTo(size: SizeFloat) -> Image? {
        let targetSize = self.size.aspectFit(size).cgSize
        let rect = NSRect(origin: .zero, size: targetSize)
        guard let representation = self.native.bestRepresentation(for: rect, context: nil, hints: nil) else {
            return nil
        }
        return Image(NSImage(
            size: targetSize,
            flipped: false,
            drawingHandler: { _ in representation.draw(in: rect) }
        ))
    }
    
}

#endif
