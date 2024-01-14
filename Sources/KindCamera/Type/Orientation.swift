//
//  KindKit
//

import AVFoundation
#if os(iOS)
import UIKit
#endif

public enum Orientation {
    
    case portrait
    case portraitUpsideDown
    case landscapeRight
    case landscapeLeft
    
}

public extension Orientation {
    
    var avOrientation: AVCaptureVideoOrientation {
        switch self {
        case .portrait: return .portrait
        case .portraitUpsideDown: return .portraitUpsideDown
        case .landscapeRight: return .landscapeRight
        case .landscapeLeft: return .landscapeLeft
        }
    }
    
}

#if os(iOS)

public extension Orientation {
    
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

public extension Orientation {
    
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
