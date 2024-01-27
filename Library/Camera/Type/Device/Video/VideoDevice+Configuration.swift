//
//  KindKit
//

extension VideoDevice {
    
    public struct Configuration {
        
        var device: VideoDevice
        
        init(
            _ device: VideoDevice
        ) {
            self.device = device
        }
        
    }
    
}

extension VideoDevice.Configuration : @unchecked Sendable {
}
