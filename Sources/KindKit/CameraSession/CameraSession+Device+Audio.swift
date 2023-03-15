//
//  KindKit
//

import AVFoundation

public extension CameraSession.Device {
    
    final class Audio {
        
        public let device: AVCaptureDevice
        public let input: AVCaptureDeviceInput
        
        init?(
            _ device: AVCaptureDevice
        ) {
            guard let input = try? AVCaptureDeviceInput(device: device) else {
                return nil
            }
            self.device = device
            self.input = input
        }
        
    }
    
}

public extension CameraSession.Device.Audio {
    
    struct Configuration {
        
        var device: CameraSession.Device.Audio
        
        init(
            _ device: CameraSession.Device.Audio
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
