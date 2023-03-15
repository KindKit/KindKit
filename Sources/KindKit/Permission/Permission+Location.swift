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
        
        private let _manager = CLLocationManager()
        
        public init(
            preferedWhen: When
        ) {
            self.preferedWhen = preferedWhen
            super.init()
        }
        
        public override func request(source: Any) {
            switch self._manager.kk_authorizationStatus {
            case .notDetermined:
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

