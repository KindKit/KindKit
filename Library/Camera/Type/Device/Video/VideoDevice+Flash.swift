//
//  KindKit
//

import AVFoundation

public extension VideoDevice {
    
    enum Flash {
        
        case auto
        case off
        case on
        
    }
    
}

extension VideoDevice.Flash : Hashable {
}

extension VideoDevice.Flash : Equatable {
}

extension VideoDevice.Flash : Sendable {
}

extension VideoDevice.Flash {
    
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
