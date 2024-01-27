//
//  KindKit
//

import CoreLocation
import KindPermission

public final class PermissionRequest : KindPermission.Request {
    
    public let preferedWhen: When
    
    public var when: When? {
        switch self._manager.kk_authorizationStatus {
        case .authorized, .authorizedAlways: return .always
        case .authorizedWhenInUse: return .inUse
        default: return nil
        }
    }
    
    private var _delegate: Delegate? {
        didSet {
            self._manager.delegate = self._delegate
        }
    }
    private let _manager = CLLocationManager()
    
    public init(
        preferedWhen: When
    ) {
        self.preferedWhen = preferedWhen
    }
    
    deinit {
        self._delegate = nil
    }
    
    public func status() async -> Status {
        switch self._manager.kk_authorizationStatus {
        case .denied, .restricted: return .denied
        case .notDetermined: return .notDetermined
        case .authorized, .authorizedAlways, .authorizedWhenInUse: return .authorized
        @unknown default: return .denied
        }
    }
    
    public func request() async {
        await withCheckedContinuation({ continuation in
            self._delegate = Delegate(continuation)
            switch self.preferedWhen {
            case .always: self._manager.requestAlwaysAuthorization()
            case .inUse: self._manager.requestWhenInUseAuthorization()
            }
        })
    }
    
}

extension PermissionRequest : @unchecked Sendable {
    
}

private extension PermissionRequest {
    
    final class Delegate : NSObject, CLLocationManagerDelegate {
        
        let continuation: CheckedContinuation< Void, Never >
        
        init(_ continuation: CheckedContinuation< Void, Never >) {
            self.continuation = continuation
            super.init()
        }
        
        func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
            self.continuation.resume()
        }

        func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
            self.continuation.resume()
        }
        
    }
    
}

fileprivate extension CLLocationManager {
    
    @inline(__always)
    var kk_authorizationStatus: CLAuthorizationStatus {
        if #available(macOS 11, iOS 14, *) {
            return self.authorizationStatus
        }
        return Self.authorizationStatus()
    }
    
}
