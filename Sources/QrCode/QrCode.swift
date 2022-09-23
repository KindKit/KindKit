//
//  KindKit
//

import Foundation
import CoreImage

public struct QrCode {
    
    public enum ErrorCorrection : String {
        case low = "L"
        case medium = "M"
        case quartile = "Q"
        case high = "H"
    }
    
    public let data: Data
    public let errorCorrection: ErrorCorrection
    
    public init(
        data: Data,
        errorCorrection: ErrorCorrection = .low
    ) {
        self.data = data
        self.errorCorrection = errorCorrection
    }
    
    public func generate(
        color: UI.Color,
        backgroundColor: UI.Color,
        insets: InsetFloat,
        size: SizeFloat
    ) -> UI.Image? {
        guard let qrFilter = CIFilter(name: "CIRCodeGenerator") else {
            return nil
        }
        qrFilter.setDefaults()
        qrFilter.setValue(self.data, forKey: "inputMessage")
        qrFilter.setValue(self.errorCorrection.rawValue, forKey: "inputCorrectionLevel")
        guard let colorFilter = CIFilter(name: "CIFalseColor") else {
            return nil
        }
        colorFilter.setDefaults()
        colorFilter.setValue(qrFilter.outputImage, forKey: "inputImage")
        colorFilter.setValue(CIColor(cgColor: color.cgColor), forKey: "inputColor0")
        colorFilter.setValue(CIColor(cgColor: backgroundColor.cgColor), forKey: "inputColor1")
        guard let ciImage = colorFilter.outputImage else {
            return nil
        }
        let ciImageSize = ciImage.extent.size
        let widthRatio = CGFloat(size.width) / ciImageSize.width
        let heightRatio = CGFloat(size.height) / ciImageSize.height
        guard
            let qrCodeCgImage = ciImage.cgImage(withScale: CGPoint(x: widthRatio, y: heightRatio)),
            let qrCodeCgColorSpace = qrCodeCgImage.colorSpace
        else {
            return nil
        }
        guard let context = CGContext(data: nil, width: Int(size.width + insets.left + insets.right), height: Int(size.height + insets.top + insets.bottom), bitsPerComponent: qrCodeCgImage.bitsPerComponent, bytesPerRow: 0, space: qrCodeCgColorSpace, bitmapInfo: qrCodeCgImage.bitmapInfo.rawValue) else {
            return nil
        }
        context.setFillColor(backgroundColor.cgColor)
        context.fill(CGRect(x: 0, y: 0, width: CGFloat(context.width), height: CGFloat(context.height)))
        context.draw(qrCodeCgImage, in: CGRect(x: CGFloat(insets.left), y: CGFloat(insets.bottom), width: CGFloat(size.width), height: CGFloat(size.height)))
        guard let cgImage = context.makeImage() else {
            return nil
        }
        return .init(cgImage)
    }
    
}
