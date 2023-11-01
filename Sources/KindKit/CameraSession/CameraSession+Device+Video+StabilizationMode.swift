//
//  KindKit
//

#if os(iOS)

import AVFoundation

public extension CameraSession.Device.Video {
    
    enum StabilizationMode {
        
        case off
        case auto
        case standard
        case cinematic
        case cinematicExtended
        case previewOptimized
        
    }
    
}

extension CameraSession.Device.Video.StabilizationMode {
    
    var raw: AVCaptureVideoStabilizationMode {
        switch self {
        case .off: return .off
        case .auto: return .auto
        case .standard: return .standard
        case .cinematic: return .cinematic
        case .cinematicExtended:
            if #available(iOS 13.0, *) {
                return .cinematicExtended
            } else {
                return .cinematic
            }
        case .previewOptimized:
#if swift(>=5.9)
            if #available(iOS 17.0, *) {
                return .previewOptimized
            } else {
                return .standard
            }
#else
            return .standard
#endif
        }
    }
    
    init?(_ raw: AVCaptureVideoStabilizationMode) {
        switch raw {
        case .off: self = .off
        case .auto: self = .auto
        case .standard: self = .standard
        case .cinematic: self = .cinematic
        case .cinematicExtended: self = .cinematicExtended
#if swift(>=5.9)
        case .previewOptimized: self = .previewOptimized
#endif
        @unknown default: return nil
        }
    }
    
}

#endif
