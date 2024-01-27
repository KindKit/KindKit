//
//  KindKit
//

import AVFoundation
import KindPermission

public final class PermissionRequest : KindPermission.Request {
    
    public init() {
    }
    
    public func status() async -> KindPermission.Status {
        switch AVCaptureDevice.kk_authorizationStatus {
        case .notDetermined: return .notDetermined
        case .denied, .restricted: return .denied
        case .authorized: return .authorized
        default: return .denied
        }
    }
    
    public func request() async {
        await AVCaptureDevice.requestAccess(for: .audio)
    }
    
}

fileprivate extension AVCaptureDevice {
    
    @inline(__always)
    static var kk_authorizationStatus: AVAuthorizationStatus {
        return AVCaptureDevice.authorizationStatus(for: .audio)
    }
    
}
