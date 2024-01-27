//
//  KindKit
//

import Foundation

#if os(iOS)

public extension VideoDevice {
    
    enum LowLightBoost {
        
        case disabled
        case enabled
        
    }
    
}

extension VideoDevice.LowLightBoost : Hashable {
}

extension VideoDevice.LowLightBoost : Equatable {
}

extension VideoDevice.LowLightBoost : Sendable {
}

public extension VideoDevice {
    
    func isLowLightBoostSupported() -> Bool {
        return self.handle.isLowLightBoostSupported
    }
    
    func lowLightBoost() -> LowLightBoost? {
        if self.handle.automaticallyEnablesLowLightBoostWhenAvailable == true {
            return .enabled
        }
        return .disabled
    }
    
}

public extension VideoDevice.Configuration {
    
    func isLowLightBoostSupported() -> Bool {
        return self.device.isLowLightBoostSupported()
    }
    
    func lowLightBoost() -> VideoDevice.LowLightBoost? {
        return self.device.lowLightBoost()
    }
    
    func set(lowLightBoost: VideoDevice.LowLightBoost) {
        switch lowLightBoost {
        case .disabled: self.device.handle.automaticallyEnablesLowLightBoostWhenAvailable = false
        case .enabled: self.device.handle.automaticallyEnablesLowLightBoostWhenAvailable = true
        }
    }
    
}

#endif
