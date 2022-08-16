//
//  KindKitView
//

import KindKitCore
import KindKitMath

#if os(iOS)

import UIKit
import ImageIO

public struct Image : Equatable {

    public var native: UIImage
    public var size: SizeFloat
    public var scale: Float
    
    @inlinable
    public init(
        name: String,
        in bundle: Bundle? = nil,
        compatibleWith traitCollection: UITraitCollection? = nil,
        renderingMode: UIImage.RenderingMode? = nil
    ) {
        guard let image = UIImage(named: name, in: bundle, compatibleWith: traitCollection) else {
            fatalError("Not found image with '\(name)'")
        }
        if let renderingMode = renderingMode {
            self.native = image.withRenderingMode(renderingMode)
        } else {
            self.native = image
        }
        self.size = SizeFloat(image.size)
        self.scale = Float(image.scale)
    }
    
    @inlinable
    public init(
        names: [String],
        in bundle: Bundle? = nil,
        compatibleWith traitCollection: UITraitCollection? = nil,
        duration: TimeInterval,
        renderingMode: UIImage.RenderingMode? = nil
    ) {
        guard let image = UIImage.animatedImage(with: names.compactMap({ UIImage(named: $0, in: bundle, compatibleWith: traitCollection) }), duration: duration) else {
            fatalError("Not found images with '\(names)'")
        }
        if let renderingMode = renderingMode {
            self.native = image.withRenderingMode(renderingMode)
        } else {
            self.native = image
        }
        self.size = SizeFloat(image.size)
        self.scale = Float(image.scale)
    }
    
    public init?(
        data: Data,
        renderingMode: UIImage.RenderingMode? = nil
    ) {
        guard let image = Self._create(data: data, renderingMode: renderingMode) else { return nil }
        self.native = image
        self.size = SizeFloat(image.size)
        self.scale = Float(image.scale)
    }
    
    public init?(
        url: URL,
        renderingMode: UIImage.RenderingMode? = nil
    ) {
        guard let data = try? Data(contentsOf: url) else { return nil }
        guard let image = Self._create(data: data, renderingMode: renderingMode) else { return nil }
        self.native = image
        self.size = SizeFloat(image.size)
        self.scale = Float(image.scale)
    }
    
    @inlinable
    public init(
        _ uiImage: UIImage
    ) {
        self.native = uiImage
        self.size = SizeFloat(uiImage.size)
        self.scale = Float(uiImage.scale)
    }
    
    @inlinable
    public init(
        uiImages: [UIImage],
        duration: TimeInterval,
        renderingMode: UIImage.RenderingMode? = nil
    ) {
        guard let image = UIImage.animatedImage(with: uiImages, duration: duration) else {
            fatalError("Invalid create animated image")
        }
        if let renderingMode = renderingMode {
            self.native = image.withRenderingMode(renderingMode)
        } else {
            self.native = image
        }
        self.size = SizeFloat(image.size)
        self.scale = Float(image.scale)
    }
    
    @inlinable
    public init(
        _ cgImage: CGImage
    ) {
        self.native = UIImage(cgImage: cgImage)
        self.size = SizeFloat(self.native.size)
        self.scale = Float(self.native.scale)
    }
    
    public init?(size: SizeFloat, scale: Float? = nil, color: Color) {
        let realScale = scale ?? Float(UIScreen.main.scale)
        UIGraphicsBeginImageContextWithOptions(size.cgSize, false, CGFloat(realScale))
        defer {
            UIGraphicsEndImageContext()
        }
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        context.setFillColor(color.cgColor)
        context.fill(CGRect(x: 0, y: 0, width: CGFloat(size.width), height: CGFloat(size.height)))
        guard let image = context.makeImage() else {
            return nil
        }
        self.native = UIImage(cgImage: image)
        self.size = SizeFloat(width: Float(image.width), height: Float(image.height))
        self.scale = realScale
    }
    
}

public extension Image {
    
    var cgImage: CGImage? {
        return self.native.cgImage
    }
    
    var grayscale: Image? {
        let context = CIContext(options: nil)
        guard let filter = CIFilter(name: "CIPhotoEffectNoir") else {
            return nil
        }
        filter.setValue(CIImage(image: self.native), forKey: kCIInputImageKey)
        if let output = filter.outputImage, let cgImage = context.createCGImage(output, from: output.extent) {
            return Image(UIImage(cgImage: cgImage, scale: self.native.scale, orientation: self.native.imageOrientation))
        }
        return nil
    }
    
}

public extension Image {
    
    func pngData() -> Data? {
        return self.native.pngData()
    }
    
    func withRenderingMode(renderingMode: UIImage.RenderingMode) -> Image {
        return Image(self.native.withRenderingMode(renderingMode))
    }
    
    func unrotate(maxResolution: Float) -> Image {
        guard let imgRef = self.native.cgImage else {
            return self
        }
        let width = CGFloat(imgRef.width);
        let height = CGFloat(imgRef.height);
        var bounds = CGRect(x: 0, y: 0, width: width, height: height)
        var scaleRatio : CGFloat = 1
        if width > CGFloat(maxResolution) || height > CGFloat(maxResolution) {
            scaleRatio = min(CGFloat(maxResolution) / bounds.size.width, CGFloat(maxResolution) / bounds.size.height)
            bounds.size.height = bounds.size.height * scaleRatio
            bounds.size.width = bounds.size.width * scaleRatio
        }
        let orientation = self.native.imageOrientation
        var transform = CGAffineTransform.identity
        let imageSize = CGSize(width: CGFloat(imgRef.width), height: CGFloat(imgRef.height))
        switch orientation {
        case .up:
            transform = CGAffineTransform.identity
        case .upMirrored:
            transform = CGAffineTransform(translationX: imageSize.width, y: 0.0)
            transform = transform.scaledBy(x: -1.0, y: 1.0)
        case .down:
            transform = CGAffineTransform(translationX: imageSize.width, y: imageSize.height)
            transform = transform.rotated(by: .pi)
        case .downMirrored:
            transform = CGAffineTransform(translationX: 0.0, y: imageSize.height)
            transform = transform.scaledBy(x: 1.0, y: -1.0)
        case .left:
            let storedHeight = bounds.size.height
            bounds.size.height = bounds.size.width
            bounds.size.width = storedHeight
            transform = CGAffineTransform(translationX: 0.0, y: imageSize.width)
            transform = transform.rotated(by: 3.0 * .pi / 2.0)
        case .leftMirrored:
            let storedHeight = bounds.size.height
            bounds.size.height = bounds.size.width
            bounds.size.width = storedHeight
            transform = CGAffineTransform(translationX: imageSize.height, y: imageSize.width)
            transform = transform.scaledBy(x: -1.0, y: 1.0)
            transform = transform.rotated(by: 3.0 * .pi / 2.0)
        case .right:
            let storedHeight = bounds.size.height
            bounds.size.height = bounds.size.width
            bounds.size.width = storedHeight
            transform = CGAffineTransform(translationX: imageSize.height, y: 0.0)
            transform = transform.rotated(by: .pi / 2.0)
        case .rightMirrored:
            let storedHeight = bounds.size.height
            bounds.size.height = bounds.size.width
            bounds.size.width = storedHeight
            transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            transform = transform.rotated(by: .pi / 2.0)
        @unknown default:
            fatalError()
        }
        UIGraphicsBeginImageContext(bounds.size)
        guard let context = UIGraphicsGetCurrentContext() else {
            return self
        }
        if orientation == .right || orientation == .left {
            context.scaleBy(x: -scaleRatio, y: scaleRatio)
            context.translateBy(x: -height, y: 0)
        } else {
            context.scaleBy(x: scaleRatio, y: -scaleRatio)
            context.translateBy(x: 0, y: -height)
        }
        context.concatenate(transform)
        context.draw(imgRef, in: CGRect(x: 0, y: 0, width: width, height: height))
        guard let imageCopy = UIGraphicsGetImageFromCurrentImageContext() else {
            return self
        }
        UIGraphicsEndImageContext()
        return Image(imageCopy)
    }
    
    func scaleTo(size: SizeFloat) -> Image? {
        guard let cgImage = self.native.cgImage else {
            return nil
        }
        let scale = self.native.scale
        let aspectSize = self.size.aspectFit(size)
        UIGraphicsBeginImageContextWithOptions(aspectSize.cgSize, false, scale)
        defer {
            UIGraphicsEndImageContext()
        }
        if let context = UIGraphicsGetCurrentContext() {
            context.translateBy(x: 0, y: CGFloat(aspectSize.height))
            context.scaleBy(x: 1.0, y: -1.0)
            context.draw(cgImage, in: CGRect(origin: .zero, size: aspectSize.cgSize))
            if let image = context.makeImage() {
                return Image(UIImage(cgImage: image, scale: scale, orientation: .up))
            }
        }
        return nil
    }
    
}

private extension Image {
    
    static func _create(
        data: Data,
        renderingMode: UIImage.RenderingMode? = nil
    ) -> UIImage? {
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else { return nil }
        let image: UIImage
        let count = CGImageSourceGetCount(source)
        if count > 1 {
            var frameImages: [UIImage] = []
            var frameDurations: [TimeInterval] = []
            for index in 0 ..< count {
                guard let frameImage = CGImageSourceCreateImageAtIndex(source, index, nil) else { continue }
                frameImages.append(UIImage(cgImage: frameImage))
                
                var frameDuration: TimeInterval = 0
                if let frameProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil) as? [AnyHashable : Any] {
                    if let gifInfo = frameProperties[kCGImagePropertyGIFDictionary] as? [AnyHashable : Any] {
                        if let gifDelayTime = gifInfo[kCGImagePropertyGIFDelayTime] as? NSNumber {
                            frameDuration = TimeInterval(gifDelayTime.doubleValue)
                        }
                    }
                }
                frameDurations.append(frameDuration)
            }
            var totalDuration: TimeInterval = 0
            for frameDuration in frameDurations {
                totalDuration += frameDuration
            }
            if let animatedImage = UIImage.animatedImage(with: frameImages, duration: totalDuration) {
                image = animatedImage
            } else {
                return nil
            }
        } else if let cgImage = CGImageSourceCreateImageAtIndex(source, 0, nil) {
            image = UIImage(cgImage: cgImage)
        } else {
            return nil
        }
        if let renderingMode = renderingMode {
            return image.withRenderingMode(renderingMode)
        }
        return image
    }
    
}

#endif
