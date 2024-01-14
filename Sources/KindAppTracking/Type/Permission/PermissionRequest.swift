//
//  KindKit
//

import AppTrackingTransparency
import KindPermission

public final class PermissionRequest : KindPermission.IRequest {
    
    public var status: KindPermission.Status {
        if #available(macOS 11.0, iOS 14.5, *) {
            switch ATTrackingManager.trackingAuthorizationStatus {
            case .notDetermined: return .notDetermined
            case .restricted, .denied: return .denied
            case .authorized: return .authorized
            @unknown default: return .denied
            }
        } else {
            return .notSupported
        }
    }
    
    public init() {
    }
    
    public func request(_ completion: @escaping () -> Void) {
        if #available(macOS 11.0, iOS 14.5, *) {
            ATTrackingManager.requestTrackingAuthorization(
                completionHandler: { _ in
                    DispatchQueue.main.async(execute: completion)
                }
            )
        }
    }
    
}
