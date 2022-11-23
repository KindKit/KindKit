//
//  KindKit
//


#if os(macOS)

import AppKit
import ImageIO

public extension UI.Image {
    
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
        self.native = image
        self.size = Size(image.size)
        self.scale = 1
    }
    
    init?(
        url: URL
    ) {
        guard let image = NSImage(contentsOf: url) else { return nil }
        self.native = image
        self.size = Size(image.size)
        self.scale = 1
    }
    
    init(
        _ native: NSImage
    ) {
        self.native = native
        self.size = Size(native.size)
        self.scale = 1
    }
    
    init(
        _ cgImage: CGImage
    ) {
        self.native = NSImage(cgImage: cgImage, size: .zero)
        self.size = Size(self.native.size)
        self.scale = 1
    }
    
}

public extension UI.Image {
    
    var cgImage: CGImage? {
        return self.native.cgImage(forProposedRect: nil, context: nil, hints: nil)
    }
    
    var grayscale: UI.Image? {
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

public extension UI.Image {
    
    func pngData() -> Data? {
        guard let data = self.native.tiffRepresentation else { return nil }
        guard let representation = NSBitmapImageRep(data: data) else { return nil }
        return representation.representation(using: .png, properties: [:])
    }
    
    func scaleTo(size: Size) -> UI.Image? {
        let targetSize = self.size.aspectFit(size).cgSize
        let rect = NSRect(origin: .zero, size: targetSize)
        guard let representation = self.native.bestRepresentation(for: rect, context: nil, hints: nil) else {
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
