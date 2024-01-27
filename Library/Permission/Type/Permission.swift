//
//  KindKit
//

#if os(iOS)
import UIKit
#endif
import KindEvent
import KindSystem
import KindMonadicMacro

@Monadic
public final class Permission< Request : KindPermission.Request > {
    
    public let data: Request
    public private(set) var status: Status?
    
    @MonadicSignal
    public let onRedirectToSettings = Signal< Void, Void >()
    
    @MonadicSignal
    public let onWillRequest = Signal< Void, Void >()
    
    @MonadicSignal
    public let onDidRequest = Signal< Void, Void >()
    
    private var _task: Task< Void, Never >?
    private var _resignState: Status?
    
    public init(_ request: Request) {
        self.data = request
        
        self._task = Task(operation: {
            self.status = await self.data.status()
            self._task = nil
        })
        
        AppState.default.onResignActive(target: self, regular: { target in
            Task(operation: {
                await target._resignActive()
            })
        })
        AppState.default.onBecomeActive(target: self, regular: { target in
            Task(operation: {
                await target._becomeActive()
            })
        })
    }
    
    deinit {
        AppState.default.onResignActive(disconnect: self)
        AppState.default.onBecomeActive(disconnect: self)
    }
    
    public func request() async -> Bool {
        switch self.status {
        case .notDetermined:
            self.onWillRequest.emit()
            await self.data.request()
            self.onDidRequest.emit()
            return true
        case .denied:
            return await self.redirectToSettings()
        default:
            return false
        }
    }
    
    func redirectToSettings() async -> Bool {
#if os(iOS)
        return await MainActor.run(body: {
            guard let url = URL(string: UIApplication.openSettingsURLString) else { return false }
            guard UIApplication.shared.canOpenURL(url) == true else { return false }
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            self.onRedirectToSettings.emit()
            return true
        })
#else
        return false
#endif
    }
    
}

extension Permission : @unchecked Sendable {
}

fileprivate extension Permission {
    
    func _resignActive() async {
        switch self.status {
        case .authorized: self._resignState = .authorized
        case .denied: self._resignState = .denied
        default: self._resignState = nil
        }
    }
    
    func _becomeActive() async {
        guard let resignState = self._resignState else { return }
        if self.status != resignState {
            self.onDidRequest.emit()
        }
        self._resignState = nil
    }
    
}
