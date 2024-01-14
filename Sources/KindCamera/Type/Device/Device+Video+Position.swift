//
//  KindKit
//

import AVFoundation

public extension Device.Video {
    
    enum Position {
        
        case unspecified
        case front
        case rear
        
    }
    
}

extension Device.Video.Position {
    
    var raw: AVCaptureDevice.Position {
        switch self {
        case .unspecified: return .unspecified
        case .front: return .front
        case .rear: return .back
        }
    }
    
    init?(_ raw: AVCaptureDevice.Position) {
        switch raw {
        case .unspecified: self = .unspecified
        case .front: self = .front
        case .back: self = .rear
        @unknown default: return nil
        }
    }
    
}
