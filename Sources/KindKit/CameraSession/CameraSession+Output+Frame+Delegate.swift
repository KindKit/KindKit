//
//  KindKit
//

import AVFoundation

extension CameraSession.Output.Frame {
    
    final class Delegate : NSObject, AVCaptureVideoDataOutputSampleBufferDelegate {
        
        weak var output: CameraSession.Output.Frame?
        
        init(
            output: CameraSession.Output.Frame
        ) {
            self.output = output
            super.init()
        }
        
        func captureOutput(
            _ output: AVCaptureOutput,
            didOutput sampleBuffer: CMSampleBuffer,
            from connection: AVCaptureConnection
        ) {
            guard let output = self.output else { return }
            guard let image = self._image(sampleBuffer) else { return }
            output.frame(image)
        }
        
    }
    
}

private extension CameraSession.Output.Frame.Delegate {
    
    func _image(_ sampleBuffer: CMSampleBuffer) -> UI.Image? {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return nil
        }
        CVPixelBufferLockBaseAddress(pixelBuffer, .readOnly)
        defer {
            CVPixelBufferUnlockBaseAddress(pixelBuffer, .readOnly)
        }
        let baseAddress = CVPixelBufferGetBaseAddress(pixelBuffer)
        let width = CVPixelBufferGetWidth(pixelBuffer)
        let height = CVPixelBufferGetHeight(pixelBuffer)
        let bytesPerRow = CVPixelBufferGetBytesPerRow(pixelBuffer)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedFirst.rawValue | CGBitmapInfo.byteOrder32Little.rawValue)
        guard let context = CGContext(data: baseAddress, width: width, height: height, bitsPerComponent: 8, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo.rawValue) else {
            return nil
        }
        guard let cgImage = context.makeImage() else {
            return nil
        }
#if os(macOS)
        let image = NSImage(cgImage: cgImage, size: .init(width: width, height: height))
#elseif os(iOS)
        let image = UIImage(cgImage: cgImage, scale: 1, orientation: .right)
#endif
        return .init(image)
    }
    
}
