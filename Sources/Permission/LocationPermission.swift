//
//  KindKitPermission
//

import Foundation
#if os(iOS)
import UIKit
#endif
import CoreLocation
import KindKitObserver

public class LocationPermission : IPermission {
    
    public let preferedWhen: When
    public var status: PermissionStatus {
        guard CLLocationManager.locationServicesEnabled() == true else { return .notSupported }
        switch self._rawStatus() {
        case .denied, .restricted: return .denied
        case .notDetermined: return .notDetermined
        case .authorized, .authorizedAlways, .authorizedWhenInUse: return .authorized
        @unknown default: return .denied
        }
    }
    public var when: When? {
        guard CLLocationManager.locationServicesEnabled() == true else { return nil }
        switch self._rawStatus() {
        case .authorized, .authorizedAlways: return .always
        case .authorizedWhenInUse: return .inUse
        default: return nil
        }
    }
    
    private var _observer: Observer< IPermissionObserver >
    private var _locationManager: CLLocationManager
    private var _resignSource: Any?
    private var _resignState: PermissionStatus?
    #if os(iOS)
    private var _becomeActiveObserver: NSObjectProtocol?
    private var _resignActiveObserver: NSObjectProtocol?
    #endif
    
    public init(
        preferedWhen: When
    ) {
        self.preferedWhen = preferedWhen
        self._observer = Observer()
        self._locationManager = CLLocationManager()
        #if os(iOS)
        self._becomeActiveObserver = NotificationCenter.default.addObserver(
            forName: UIApplication.didBecomeActiveNotification,
            object: nil,
            queue: OperationQueue.main,
            using: { [unowned self] in self._didBecomeActive($0) }
        )
        self._resignActiveObserver = NotificationCenter.default.addObserver(
            forName: UIApplication.willResignActiveNotification,
            object: nil,
            queue: OperationQueue.main,
            using: { [unowned self] in self._didResignActive($0) }
        )
        #endif
    }
    
    deinit {
        #if os(iOS)
        if let observer = self._becomeActiveObserver {
            NotificationCenter.default.removeObserver(observer)
        }
        if let observer = self._resignActiveObserver {
            NotificationCenter.default.removeObserver(observer)
        }
        #endif
    }
    
    public func add(observer: IPermissionObserver, priority: ObserverPriority) {
        self._observer.add(observer, priority: priority)
    }
    
    public func remove(observer: IPermissionObserver) {
        self._observer.remove(observer)
    }
    
    public func request(source: Any) {
        switch self._rawStatus() {
        case .notDetermined:
            self._willRequest(source: source)
            UNUserNotificationCenter.current().requestAuthorization(
                options: [ .badge, .alert, .sound ],
                completionHandler: { [weak self] settings, error in
                    DispatchQueue.main.async(execute: {
                        self?._didRequest(source: source)
                    })
                }
            )
        case .denied:
            #if os(iOS)
            guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
            if UIApplication.shared.canOpenURL(url) == true {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                self._resignSource = source
                self._didRedirectToSettings(source: source)
            }
            #endif
        default:
            break
        }
    }
    
}

public extension LocationPermission {
    
    enum When {
        case always
        case inUse
    }
    
}

#if os(iOS)

private extension LocationPermission {
    
    func _didBecomeActive(_ notification: Notification) {
        guard let resignState = self._resignState else { return }
        if resignState != self.status {
            self._didRequest(source: self._resignSource)
        }
        self._resignSource = nil
        self._resignState = nil
    }
    
    func _didResignActive(_ notification: Notification) {
        switch self.status {
        case .authorized: self._resignState = .authorized
        case .denied: self._resignState = .denied
        default: self._resignState = nil
        }
    }
    
}

#endif

private extension LocationPermission {
    
    func _rawStatus() -> CLAuthorizationStatus {
        if #available(iOS 14, *) {
            return self._locationManager.authorizationStatus
        }
        return CLLocationManager.authorizationStatus()
    }
    
    func _didRedirectToSettings(source: Any) {
        self._observer.notify({ $0.didRedirectToSettings(self, source: source) })
    }
    
    func _willRequest(source: Any?) {
        self._observer.notify({ $0.willRequest(self, source: source) })
    }
    
    func _didRequest(source: Any?) {
        switch self.preferedWhen {
        case .always: self._locationManager.requestAlwaysAuthorization()
        case .inUse: self._locationManager.requestWhenInUseAuthorization()
        }
        self._observer.notify({ $0.didRequest(self, source: source) })
    }
    
}
