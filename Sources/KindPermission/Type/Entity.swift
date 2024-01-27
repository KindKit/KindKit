//
//  KindKit
//

#if os(iOS)
import UIKit
#endif
import KindEvent
import KindSystem

public final class Entity< RequestType : IRequest > : IEntity {
    
    public let request: RequestType
    
    public var status: Status {
        return self.request.status
    }
    
    public let observer = Observer< IObserver >()
    
    private var _resignSource: Any?
    private var _resignState: Status?
    
    public init(_ request: RequestType) {
        self.request = request
        AppState.default.add(observer: self, priority: .internal)
    }
    
    deinit {
        AppState.default.remove(observer: self)
    }
    
}

public extension Entity {
    
    func request(source: Any) -> Bool {
        switch self.request.status {
        case .notDetermined:
            self.observer.emit({ $0.willRequest(self, source: source) })
            self.request.request({ [weak self] in
                guard let self = self else { return }
                self.observer.emit({ $0.didRequest(self, source: source) })
            })
            return true
        case .denied:
            return self.redirectToSettings(source: source)
        default:
            return false
        }
    }
    
    func redirectToSettings(source: Any) -> Bool {
#if os(iOS)
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return false }
        guard UIApplication.shared.canOpenURL(url) == true else { return false }
        self._resignSource = source
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
        self.observer.emit({ $0.redirectToSettings(self, source: source) })
        return true
#else
        return false
#endif
    }
    
}

extension Entity : IAppStateObserver {
    
    public func didResignActive(_ appState: AppState) {
        switch self.status {
        case .authorized: self._resignState = .authorized
        case .denied: self._resignState = .denied
        default: self._resignState = nil
        }
    }
    
    public func didBecomeActive(_ appState: AppState) {
        guard let resignState = self._resignState else { return }
        if resignState != self.status {
            self.observer.emit({ $0.didRequest(self, source: self._resignSource) })
        }
        self._resignSource = nil
        self._resignState = nil
    }
    
}
