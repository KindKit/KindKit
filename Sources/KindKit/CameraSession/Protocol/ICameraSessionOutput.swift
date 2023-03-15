//
//  KindKit
//

import AVFoundation

public protocol ICameraSessionOutput : AnyObject {
    
    var deviceOrientation: CameraSession.Orientation? { set get }
    var interfaceOrientation: CameraSession.Orientation? { set get }
    var output: AVCaptureOutput { get }
    
    func cancel()
    
}
