//
//  KindKit
//

import AVFoundation

public protocol ICameraSessionOutput : AnyObject {
    
    var session: CameraSession? { get }
#if os(iOS)
    var deviceOrientation: CameraSession.Orientation? { set get }
    var interfaceOrientation: CameraSession.Orientation? { set get }
#endif
    var output: AVCaptureOutput { get }
    
    func attach(session: CameraSession)
    func detach()
    
}

public extension ICameraSessionOutput {
    
    @inlinable
    var isAttached: Bool {
        return self.session != nil
    }
    
    @inlinable
    var videoConnection: AVCaptureConnection? {
        return self.output.connection(with: .video)
    }
    
#if os(iOS)
    
    func resolveOrientation(shouldRotateToDevice: Bool) -> CameraSession.Orientation {
        if shouldRotateToDevice == true {
            switch self.deviceOrientation {
            case .portrait: return .portrait
            case .portraitUpsideDown: return .portraitUpsideDown
            case .landscapeRight: return .landscapeLeft
            case .landscapeLeft: return .landscapeRight
            case .none:
                if let interfaceOrientation = self.interfaceOrientation {
                    return interfaceOrientation
                }
            }
        } else if let interfaceOrientation = self.interfaceOrientation {
            return interfaceOrientation
        }
        return .portrait
    }
    
    func apply(videoOrientation: CameraSession.Orientation) {
        guard let connection = self.videoConnection else { return }
        if connection.isVideoOrientationSupported == true {
            connection.videoOrientation = videoOrientation.avOrientation
        }
    }
    
#endif
    
}
