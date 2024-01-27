//
//  KindKit
//

import AVFoundation

public extension VideoDevice {
    
    enum Preset {
        
        case high
        case medium
        case low
        case fixed352x288
        case fixed640x480
        case fixed960x540
        case fixed1280x720
        case fixed1920x1080
        case fixed3840x2160
        
    }
    
}

extension VideoDevice.Preset : Hashable {
}

extension VideoDevice.Preset : Equatable {
}

extension VideoDevice.Preset : Sendable {
}

public extension VideoDevice {
    
    func isPresetSupported(_ preset: VideoDevice.Preset) -> Bool {
        return self.handle.supportsSessionPreset(preset.raw)
    }
    
}

extension VideoDevice.Preset {
    
    var raw: AVCaptureSession.Preset {
        switch self {
        case .high: return .high
        case .medium: return .medium
        case .low: return .low
        case .fixed352x288: return .cif352x288
        case .fixed640x480: return .vga640x480
        case .fixed960x540: return .iFrame960x540
        case .fixed1280x720: return .hd1280x720
        case .fixed1920x1080: return .hd1920x1080
        case .fixed3840x2160: return .hd4K3840x2160
        }
    }
    
    init?(_ raw: AVCaptureSession.Preset) {
        switch raw {
        case .high: self = .high
        case .medium: self = .medium
        case .low: self = .low
        case .cif352x288: self = .fixed352x288
        case .vga640x480: self = .fixed640x480
        case .iFrame960x540: self = .fixed960x540
        case .hd1280x720: self = .fixed1280x720
        case .hd1920x1080: self = .fixed1920x1080
        case .hd4K3840x2160: self = .fixed3840x2160
        default: return nil
        }
    }
    
}
