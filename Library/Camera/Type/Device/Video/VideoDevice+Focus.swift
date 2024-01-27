//
//  KindKit
//

import AVFoundation

public extension VideoDevice {
    
    enum Focus {
        
        case locked
        case auto
        case continuous
        
    }
    
}

extension VideoDevice.Focus : Hashable {
}

extension VideoDevice.Focus : Equatable {
}

extension VideoDevice.Focus : Sendable {
}

public extension VideoDevice {
    
    func isFocusSupported(_ feature: Focus) -> Bool {
        return self.handle.isFocusModeSupported(feature.raw)
    }
    
    func focus() -> Focus? {
        return .init(self.handle.focusMode)
    }
    
}

public extension VideoDevice.Configuration {
    
    func isFocusSupported(_ feature: VideoDevice.Focus) -> Bool {
        return self.device.isFocusSupported(feature)
    }
    
    func set(focus: VideoDevice.Focus) {
        self.device.handle.focusMode = focus.raw
    }
    
    func focus() -> VideoDevice.Focus? {
        return .init(self.device.handle.focusMode)
    }
    
}

extension VideoDevice.Focus {
    
    var raw: AVCaptureDevice.FocusMode {
        switch self {
        case .locked: return .locked
        case .auto: return .autoFocus
        case .continuous: return .continuousAutoFocus
        }
    }
    
    init?(_ raw: AVCaptureDevice.FocusMode) {
        switch raw {
        case .locked: self = .locked
        case .autoFocus: self = .auto
        case .continuousAutoFocus: self = .continuous
        @unknown default: return nil
        }
    }
    
}
