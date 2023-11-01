//
//  KindKit
//

import AVFoundation

public extension CameraSession.Device.Video {
    
    enum Focus {
        
        case locked
        case auto
        case continuous
        
    }
    
}

public extension CameraSession.Device.Video {
    
    func isFocusSupported(_ feature: Focus) -> Bool {
        return self.device.isFocusModeSupported(feature.raw)
    }
    
    func focus() -> Focus? {
        return .init(self.device.focusMode)
    }
    
}

public extension CameraSession.Device.Video.Configuration {
    
    func isFocusSupported(_ feature: CameraSession.Device.Video.Focus) -> Bool {
        return self.device.isFocusSupported(feature)
    }
    
    func set(focus: CameraSession.Device.Video.Focus) {
        self.device.device.focusMode = focus.raw
    }
    
    func focus() -> CameraSession.Device.Video.Focus? {
        return .init(self.device.device.focusMode)
    }
    
}

extension CameraSession.Device.Video.Focus {
    
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
