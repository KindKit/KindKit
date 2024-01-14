//
//  KindKit
//

import UserNotifications
#if os(iOS)
import UIKit
#endif
import KindPermission

public final class PermissionRequest : KindPermission.IRequest {
    
    public var status: KindPermission.Status {
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
    
    public init() {
    }
    
    public func request(_ completion: @escaping () -> Void) {
        self._center.requestAuthorization(options: [ .badge, .alert, .sound ], completionHandler: { _, _ in
            DispatchQueue.main.async(execute: {
#if os(iOS)
                UIApplication.shared.registerForRemoteNotifications()
#endif
                completion()
            })
        })
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

