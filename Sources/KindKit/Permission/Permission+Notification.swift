//
//  KindKit
//

import UserNotifications

public extension Permission {
    
    final class Notification : Permission.Base {
        
        public override var status: Permission.Status {
            switch self._center.kk_authorizationStatus {
            case .authorized: return .authorized
            case .denied: return .denied
            case .notDetermined: return .notDetermined
            case .provisional: return .authorized
            case .ephemeral: return .authorized
            default: return .denied
            }
        }
        
        private let _center: UNUserNotificationCenter = .current()
        
        public override func request(source: Any) {
            switch self._center.kk_authorizationStatus {
            case .notDetermined:
                self.willRequest(source: source)
                UNUserNotificationCenter.current().requestAuthorization(
                    options: [ .badge, .alert, .sound ],
                    completionHandler: { [weak self] settings, error in
                        DispatchQueue.main.async(execute: {
#if os(iOS)
                            UIApplication.shared.registerForRemoteNotifications()
#endif
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

public extension IPermission where Self : Permission.Notification {
    
    static func notification() -> Self {
        return .init()
    }
    
}

fileprivate extension UNUserNotificationCenter {
    
    @inline(__always)
    var kk_authorizationStatus: UNAuthorizationStatus {
        var result: UNNotificationSettings?
        let semaphore = DispatchSemaphore(value: 0)
        self.getNotificationSettings(completionHandler: { setttings in
            result = setttings
            semaphore.signal()
        })
        semaphore.wait()
        return result!.authorizationStatus
    }
    
}
