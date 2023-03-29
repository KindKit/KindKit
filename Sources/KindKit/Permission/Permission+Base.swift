//
//  KindKit
//

import Foundation
#if os(iOS)
import UIKit
#endif

public extension Permission {
    
    class Base : IPermission {
        
        public var status: Permission.Status {
            return .notSupported
        }
        private let _observer: Observer< IPermissionObserver > = Observer()
        private var _resignSource: Any?
        private var _resignState: Permission.Status?
#if os(iOS)
        private var _becomeActiveObserver: NSObjectProtocol?
        private var _resignActiveObserver: NSObjectProtocol?
#endif
        
        public init() {
#if os(iOS)
            self._becomeActiveObserver = NotificationCenter.default.addObserver(
                forName: UIApplication.didBecomeActiveNotification,
                object: nil,
                queue: .main,
                using: { [weak self] in self?._didBecomeActive($0) }
            )
            self._resignActiveObserver = NotificationCenter.default.addObserver(
                forName: UIApplication.willResignActiveNotification,
                object: nil,
                queue: .main,
                using: { [weak self] in self?._didResignActive($0) }
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
            fatalError("Need implement this method")
        }
        
    }
    
}

private extension Permission.Base {
    
    func _didBecomeActive(_ notification: Notification) {
        guard let resignState = self._resignState else { return }
        if resignState != self.status {
            self.didRequest(source: self._resignSource)
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

extension Permission.Base {
    
    func redirectToSettings(source: Any) {
#if os(iOS)
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
        if UIApplication.shared.canOpenURL(url) == true {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            self._resignSource = source
            self._observer.notify({ $0.didRedirectToSettings(self, source: source) })
        }
#endif
    }
    
    func willRequest(source: Any?) {
        self._observer.notify({ $0.willRequest(self, source: source) })
    }
    
    func didRequest(source: Any?) {
        self._observer.notify({ $0.didRequest(self, source: source) })
    }
    
}
