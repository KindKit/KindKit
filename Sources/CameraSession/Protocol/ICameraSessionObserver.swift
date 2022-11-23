//
//  KindKit
//

import Foundation

public protocol ICameraSessionObserver : AnyObject {
    
    func started(_ camera: CameraSession)
    func stopped(_ camera: CameraSession)
    
#if os(iOS)
    
    func changed(_ camera: CameraSession, deviceOrientation: CameraSession.Orientation?)
    func changed(_ camera: CameraSession, interfaceOrientation: CameraSession.Orientation?)
    
#endif
    
    func startConfiguration(_ camera: CameraSession)
    func finishConfiguration(_ camera: CameraSession)
    
}

public extension ICameraSessionObserver {
    
#if os(iOS)
    
    func changed(_ camera: CameraSession, deviceOrientation: CameraSession.Orientation?) {
    }
    
    func changed(_ camera: CameraSession, interfaceOrientation: CameraSession.Orientation?) {
    }
    
#endif
    
}
