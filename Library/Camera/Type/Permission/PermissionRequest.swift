//
//  KindKit
//

import AVFoundation
import KindPermission

public final class PermissionRequest : KindPermission.Request {
    
    public init() {
    }
    
    public func status() async -> KindPermission.Status {
        return await Task(operation: {
            switch AVCaptureDevice.kk_authorizationStatus {
            case .notDetermined: return .notDetermined
            case .denied, .restricted: return .denied
            case .authorized: return .authorized
            default: return .denied
            }
        }).value
    }
    
    public func request() async {
        await AVCaptureDevice.requestAccess(for: .video)
    }
    
}

fileprivate extension AVCaptureDevice {
    
    @inline(__always)
    static var kk_authorizationStatus: AVAuthorizationStatus {
        return AVCaptureDevice.authorizationStatus(for: .video)
    }
    
}
