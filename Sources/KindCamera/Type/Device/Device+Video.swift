//
//  KindKit
//

import AVFoundation

public extension Device {
    
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

public extension Device.Video {
    
    struct Configuration {
        
        var device: Device.Video
        
        init(
            _ device: Device.Video
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
