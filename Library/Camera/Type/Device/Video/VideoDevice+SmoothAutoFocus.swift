//
//  KindKit
//

import Foundation

#if os(iOS)

public extension VideoDevice {
    
    enum SmoothAutoFocus {
        
        case disabled
        case enabled
        
    }
    
}

extension VideoDevice.SmoothAutoFocus : Hashable {
}

extension VideoDevice.SmoothAutoFocus : Equatable {
}

extension VideoDevice.SmoothAutoFocus : Sendable {
}

public extension VideoDevice {
    
    func isSmoothAutoFocusSupported() -> Bool {
        return self.handle.isSmoothAutoFocusSupported
    }
    
    func smoothAutoFocus() -> SmoothAutoFocus? {
        if self.handle.isSmoothAutoFocusEnabled == true {
            return .enabled
        }
        return .disabled
    }
    
}

public extension VideoDevice.Configuration {
    
    func isSmoothAutoFocusSupported() -> Bool {
        return self.device.isSmoothAutoFocusSupported()
    }
    
    func smoothAutoFocus() -> VideoDevice.SmoothAutoFocus? {
        return self.device.smoothAutoFocus()
    }
    
    func set(smoothAutoFocus: VideoDevice.SmoothAutoFocus) {
        switch smoothAutoFocus {
        case .disabled: self.device.handle.isSmoothAutoFocusEnabled = false
        case .enabled: self.device.handle.isSmoothAutoFocusEnabled = true
        }
    }
    
}

#endif
