//
//  KindKit
//

import CoreLocation
import KindPermission

public final class PermissionRequest : KindPermission.IRequest {
    
    public let preferedWhen: When
    
    public var status: Status {
        switch self._manager.kk_authorizationStatus {
        case .denied, .restricted: return .denied
        case .notDetermined: return .notDetermined
        case .authorized, .authorizedAlways, .authorizedWhenInUse: return .authorized
        @unknown default: return .denied
        }
    }
    
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
    
    public func request(_ completion: @escaping () -> Void) {
        self._delegate = Delegate({ [weak self] in
            self?._delegate = nil
            completion()
        })
        switch self.preferedWhen {
        case .always: self._manager.requestAlwaysAuthorization()
        case .inUse: self._manager.requestWhenInUseAuthorization()
        }
    }
    
}

private extension PermissionRequest {
    
    final class Delegate : NSObject, CLLocationManagerDelegate {
        
        var completion: () -> Void
        
        init(
            _ completion: @escaping () -> Void
        ) {
            self.completion = completion
            super.init()
        }
        
        func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
            self.completion()
        }

        func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
            self.completion()
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
