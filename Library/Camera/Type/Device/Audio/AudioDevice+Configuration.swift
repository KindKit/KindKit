//
//  KindKit
//

extension AudioDevice {
    
    public struct Configuration {
        
        var device: AudioDevice
        
        init(
            _ device: AudioDevice
        ) {
            self.device = device
        }
        
    }
    
}

extension AudioDevice.Configuration : @unchecked Sendable {
}
