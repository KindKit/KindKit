//
//  KindKit
//

import AVFoundation

public protocol ICameraSessionOutput : AnyObject {
    
    var session: CameraSession? { get }
    var deviceOrientation: CameraSession.Orientation? { set get }
    var interfaceOrientation: CameraSession.Orientation? { set get }
    var output: AVCaptureOutput { get }
    
    func attach(session: CameraSession)
    func detach()
    
}

public extension ICameraSessionOutput {
    
    @inlinable
    var isAttached: Bool {
        return self.session != nil
    }
    
}
