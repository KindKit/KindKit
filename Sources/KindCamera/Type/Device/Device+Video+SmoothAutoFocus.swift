//
//  KindKit
//

import Foundation

#if os(iOS)

public extension Device.Video {
    
    enum SmoothAutoFocus {
        
        case disabled
        case enabled
        
    }
    
}

public extension Device.Video {
    
    func isSmoothAutoFocusSupported() -> Bool {
        return self.device.isSmoothAutoFocusSupported
    }
    
    func smoothAutoFocus() -> SmoothAutoFocus? {
        if self.device.isSmoothAutoFocusEnabled == true {
            return .enabled
        }
        return .disabled
    }
    
}

public extension Device.Video.Configuration {
    
    func isSmoothAutoFocusSupported() -> Bool {
        return self.device.isSmoothAutoFocusSupported()
    }
    
    func smoothAutoFocus() -> Device.Video.SmoothAutoFocus? {
        return self.device.smoothAutoFocus()
    }
    
    func set(smoothAutoFocus: Device.Video.SmoothAutoFocus) {
        switch smoothAutoFocus {
        case .disabled: self.device.device.isSmoothAutoFocusEnabled = false
        case .enabled: self.device.device.isSmoothAutoFocusEnabled = true
        }
    }
    
}

#endif
