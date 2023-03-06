//
//  KindKit
//

import Foundation

#if os(iOS)

public extension CameraSession.Device.Video {
    
    enum LowLightBoost {
        
        case disabled
        case enabled
        
    }
    
}

public extension CameraSession.Device.Video {
    
    func isLowLightBoostSupported() -> Bool {
        return self.device.isLowLightBoostSupported
    }
    
    func lowLightBoost() -> LowLightBoost? {
        if self.device.automaticallyEnablesLowLightBoostWhenAvailable == true {
            return .enabled
        }
        return .disabled
    }
    
}

public extension CameraSession.Device.Video.Configuration {
    
    func isLowLightBoostSupported() -> Bool {
        return self.device.isLowLightBoostSupported()
    }
    
    func lowLightBoost() -> CameraSession.Device.Video.LowLightBoost? {
        return self.device.lowLightBoost()
    }
    
    func set(lowLightBoost: CameraSession.Device.Video.LowLightBoost) {
        switch lowLightBoost {
        case .disabled: self.device.device.automaticallyEnablesLowLightBoostWhenAvailable = false
        case .enabled: self.device.device.automaticallyEnablesLowLightBoostWhenAvailable = true
        }
    }
    
}

#endif
