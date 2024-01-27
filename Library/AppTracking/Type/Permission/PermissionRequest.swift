//
//  KindKit
//

import AppTrackingTransparency
import KindPermission

public final class PermissionRequest : KindPermission.Request {
    
    public init() {
    }
    
    public func status() async -> KindPermission.Status {
        if #available(macOS 11.0, iOS 14.5, *) {
            return await Task(operation: {
                switch ATTrackingManager.trackingAuthorizationStatus {
                case .notDetermined: return .notDetermined
                case .restricted, .denied: return .denied
                case .authorized: return .authorized
                @unknown default: return .denied
                }
            }).value
        } else {
            return .notSupported
        }
    }
    
    public func request() async {
        if #available(macOS 11.0, iOS 14.5, *) {
            await ATTrackingManager.requestTrackingAuthorization()
        }
    }
    
}
