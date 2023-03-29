//
//  KindKit
//

import CoreLocation

public extension Permission {
    
    final class Location : Permission.Base {
        
        public let preferedWhen: When
        public override var status: Permission.Status {
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
            super.init()
        }
        
        deinit {
            self._destroy()
        }
        
        public override func request(source: Any) {
            switch self._manager.kk_authorizationStatus {
            case .notDetermined:
                self._delegate = Delegate(self, source)
                self.willRequest(source: source)
                switch self.preferedWhen {
                case .always: self._manager.requestAlwaysAuthorization()
                case .inUse: self._manager.requestWhenInUseAuthorization()
                }
            case .denied:
                self.redirectToSettings(source: source)
            default:
                break
            }
        }
        
    }
    
}

private extension Permission.Location {
    
    func _destroy() {
        self._delegate = nil
    }

}

extension Permission.Location {
    
    final class Delegate : NSObject, CLLocationManagerDelegate {
        
        unowned var permission: Permission.Location
        var source: Any?
        
        init(
            _ permission: Permission.Location,
            _ source: Any
        ) {
            self.permission = permission
            self.source = source
            super.init()
        }
        
        func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
            self.permission.didRequest(source: self.source)
        }

        func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
            self.permission.didRequest(source: self.source)
        }
        
    }
    
}

public extension IPermission where Self : Permission.Location {
    
    static func location(
        preferedWhen: When
    ) -> Self {
        return .init(preferedWhen: preferedWhen)
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
