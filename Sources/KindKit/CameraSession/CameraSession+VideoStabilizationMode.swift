//
//  KindKit
//

#if os(iOS)

import AVFoundation

public extension CameraSession {
    
    enum VideoStabilizationMode {
        
        case off
        case auto
        case standard
        case cinematic
        case cinematicExtended
        case previewOptimized
        
    }
    
}

extension CameraSession.VideoStabilizationMode {
    
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
            if #available(iOS 17.0, *) {
                return .previewOptimized
            } else {
                return .standard
            }
        }
    }
    
    init?(_ raw: AVCaptureVideoStabilizationMode) {
        switch raw {
        case .off: self = .off
        case .auto: self = .auto
        case .standard: self = .standard
        case .cinematic: self = .cinematic
        case .cinematicExtended: self = .cinematicExtended
        case .previewOptimized: self = .previewOptimized
        @unknown default: return nil
        }
    }
    
}

#endif
