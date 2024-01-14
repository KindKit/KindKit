//
//  KindKit
//

import AVFoundation
import KindPermission

public final class PermissionRequest : KindPermission.IRequest {

    public var status: KindPermission.Status {
        switch AVCaptureDevice.kk_authorizationStatus {
        case .notDetermined: return .notDetermined
        case .denied, .restricted: return .denied
        case .authorized: return .authorized
        default: return .denied
        }
    }
    
    public init() {
    }
    
    public func request(_ completion: @escaping () -> Void) {
        AVCaptureDevice.requestAccess(for: .video, completionHandler: { _ in
            DispatchQueue.main.async(execute: completion)
        })
    }
    
}

fileprivate extension AVCaptureDevice {
    
    @inline(__always)
    static var kk_authorizationStatus: AVAuthorizationStatus {
        return AVCaptureDevice.authorizationStatus(for: .video)
    }
    
}
