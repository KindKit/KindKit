//
//  KindKit
//

import AppTrackingTransparency

public extension Permission {
    
    final class AppTracking : Permission.Base {
        
        public override var status: Permission.Status {
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
        
        public override func request(source: Any) {
            if #available(macOS 11.0, iOS 14.5, *) {
                switch ATTrackingManager.trackingAuthorizationStatus {
                case .notDetermined:
                    self.willRequest(source: source)
                    ATTrackingManager.requestTrackingAuthorization(
                        completionHandler: { [weak self] status in
                            DispatchQueue.main.async(execute: {
                                self?.didRequest(source: source)
                            })
                        }
                    )
                case .denied:
                    self.redirectToSettings(source: source)
                default:
                    break
                }
            }
        }
        
    }
    
}

public extension IPermission where Self : Permission.AppTracking {
    
    static func appTracking() -> Self {
        return .init()
    }
    
}
