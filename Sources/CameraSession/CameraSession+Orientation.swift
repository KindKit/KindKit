//
//  KindKit
//

import Foundation
import AVFoundation

public extension CameraSession {
    
    enum Orientation {
        
        case portrait
        case portraitUpsideDown
        case landscapeRight
        case landscapeLeft
        
    }
    
}

extension CameraSession.Orientation {
    
    var avOrientation: AVCaptureVideoOrientation {
        switch self {
        case .portrait: return .portrait
        case .portraitUpsideDown: return .portraitUpsideDown
        case .landscapeRight: return .landscapeRight
        case .landscapeLeft: return .landscapeLeft
        }
    }
    
    init?(_ avOrientation: AVCaptureVideoOrientation) {
        switch avOrientation {
        case .portrait: self = .portrait
        case .portraitUpsideDown: self = .portraitUpsideDown
        case .landscapeRight: self = .landscapeRight
        case .landscapeLeft: self = .landscapeLeft
        @unknown default: return nil
        }
    }
    
}

#if os(iOS)

extension CameraSession.Orientation {
    
    var uiDeviceOrientation: UIDeviceOrientation {
        switch self {
        case .portrait: return .portrait
        case .portraitUpsideDown: return .portraitUpsideDown
        case .landscapeRight: return .landscapeRight
        case .landscapeLeft: return .landscapeLeft
        }
    }
    
    init?(_ uiDeviceOrientation: UIDeviceOrientation) {
        switch uiDeviceOrientation {
        case .portrait: self = .portrait
        case .portraitUpsideDown: self = .portraitUpsideDown
        case .landscapeRight: self = .landscapeRight
        case .landscapeLeft: self = .landscapeLeft
        default: return nil
        }
    }
    
}

extension CameraSession.Orientation {
    
    var uiInterfaceOrientation: UIInterfaceOrientation {
        switch self {
        case .portrait: return .portrait
        case .portraitUpsideDown: return .portraitUpsideDown
        case .landscapeRight: return .landscapeRight
        case .landscapeLeft: return .landscapeLeft
        }
    }
    
    init?(_ uiInterfaceOrientation: UIInterfaceOrientation) {
        switch uiInterfaceOrientation {
        case .portrait: self = .portrait
        case .portraitUpsideDown: self = .portraitUpsideDown
        case .landscapeRight: self = .landscapeRight
        case .landscapeLeft: self = .landscapeLeft
        default: return nil
        }
    }
    
}

#endif
