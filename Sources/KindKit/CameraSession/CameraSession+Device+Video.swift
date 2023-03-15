//
//  KindKit
//

import AVFoundation

public extension CameraSession.Device {
    
    final class Video {
        
        public let device: AVCaptureDevice
        public let input: AVCaptureDeviceInput
        public let position: Position
        public let builtIn: BuiltIn
        
        init?(
            _ device: AVCaptureDevice
        ) {
            guard let position = Position(device.position) else {
                return nil
            }
            guard let builtIn = BuiltIn(device.deviceType) else {
                return nil
            }
            guard let input = try? AVCaptureDeviceInput(device: device) else {
                return nil
            }
            self.device = device
            self.input = input
            self.position = position
            self.builtIn = builtIn
        }
        
    }
    
}

public extension CameraSession.Device.Video {
    
    struct Configuration {
        
        var device: CameraSession.Device.Video
        
        init(
            _ device: CameraSession.Device.Video
        ) {
            self.device = device
        }
        
    }
    
    func configuration(_ block: (Configuration) throws -> Void) throws {
        do {
            try self.device.lockForConfiguration()
            try block(.init(self))
            self.device.unlockForConfiguration()
        } catch let error {
            throw error
        }
    }
    
}
