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
        case cinematicExtendedEnhanced
        case previewOptimized
        case lowLatency

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
        case .cinematicExtendedEnhanced:
            if #available(iOS 18.0, *) {
                return .cinematicExtendedEnhanced
            } else {
                return .cinematic
            }
        case .previewOptimized:
            if #available(iOS 17.0, *) {
                return .previewOptimized
            } else {
                return .standard
            }
        case .lowLatency:
            if #available(iOS 26.0, *) {
                return .lowLatency
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
        case .cinematicExtendedEnhanced: self = .cinematicExtendedEnhanced
        case .previewOptimized: self = .previewOptimized
        case .lowLatency: self = .lowLatency
        @unknown default: return nil
        }
    }
    
}

#endif
