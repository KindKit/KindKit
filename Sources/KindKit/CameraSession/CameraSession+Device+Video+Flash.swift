//
//  KindKit
//

import AVFoundation

public extension CameraSession.Device.Video {
    
    enum Flash {
        
        case auto
        case off
        case on
        
    }
    
}

extension CameraSession.Device.Video.Flash {
    
    var raw: AVCaptureDevice.FlashMode {
        switch self {
        case .auto: return .auto
        case .off: return .off
        case .on: return .on
        }
    }
    
    init?(_ raw: AVCaptureDevice.FlashMode) {
        switch raw {
        case .auto: self = .auto
        case .off: self = .off
        case .on: self = .on
        @unknown default: return nil
        }
    }
    
}
