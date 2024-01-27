//
//  KindKit
//

#if os(iOS)

import AVFoundation

public extension VideoDevice {
    
    enum StabilizationMode {
        
        case off
        case auto
        case standard
        case cinematic
        case cinematicExtended
        case cinematicExtendedEnhanced
        case previewOptimized
        
    }
    
}

extension VideoDevice.StabilizationMode : Hashable {
}

extension VideoDevice.StabilizationMode : Equatable {
}

extension VideoDevice.StabilizationMode : Sendable {
}

extension VideoDevice.StabilizationMode {
    
    var raw: AVCaptureVideoStabilizationMode {
        switch self {
        case .off: return .off
        case .auto: return .auto
        case .standard: return .standard
        case .cinematic: return .cinematic
        case .cinematicExtended: return .cinematicExtended
        case .cinematicExtendedEnhanced:
            if #available(iOS 18.0, *) {
                return .cinematicExtendedEnhanced
            } else {
                return .cinematicExtended
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
        case .cinematicExtendedEnhanced:  self = .cinematicExtendedEnhanced
        @unknown default: return nil
        }
    }
    
}

#endif
