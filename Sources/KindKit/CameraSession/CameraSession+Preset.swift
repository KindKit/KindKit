//
//  KindKit
//

import AVFoundation

public extension CameraSession {
    
    enum Preset {
        
        case high
        case medium
        case low
        
    }
    
}

extension CameraSession.Preset {
    
    var raw: AVCaptureSession.Preset {
        switch self {
        case .high: return .high
        case .medium: return .medium
        case .low: return .low
        }
    }
    
    init?(_ raw: AVCaptureSession.Preset) {
        switch raw {
        case .high: self = .high
        case .medium: self = .medium
        case .low: self = .low
        default: return nil
        }
    }
    
}
