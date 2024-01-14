//
//  KindKit
//

import AVFoundation

public extension Device {
    
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

public extension Device.Audio {
    
    struct Configuration {
        
        var device: Device.Audio
        
        init(
            _ device: Device.Audio
        ) {
            self.device = device
        }
        
    }
    
    @discardableResult
    func configuration(_ block: (Configuration) -> Void) -> Bool {
        do {
            try self.device.lockForConfiguration()
            block(.init(self))
            self.device.unlockForConfiguration()
        } catch {
            return false
        }
        return true
    }
    
}
