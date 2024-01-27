//
//  DSCore
//

#if os(iOS)
import BackgroundTasks
#endif
import KindEvent
import KindMonadicMacro

@Monadic
public final class BackgroundTaskManager {
    
    public let name: String

    @MonadicSignal
    public let onExpiredSession = Signal< Void, Void >()
    
#if os(iOS)
    private var _request: BGTaskRequest?
    private var _task: BGTask?
#endif
    
    public init(name: String) {
        self.name = name
#if os(iOS)
        BGTaskScheduler.shared.register(forTaskWithIdentifier: name, using: .main, launchHandler: { [weak self] task in
            guard let self = self else { return }
            self._handle(task)
        })
#endif
    }
    
    public func request() {
        guard self._request == nil else { return }
    }
    
    public func markAsSuccess() {
    }
    
    public func markAsFailure() {
    }
    
}

extension BackgroundTaskManager : @unchecked Sendable {
}

fileprivate extension BackgroundTaskManager {
    
    func _handle(_ task: BGTask) {
        self._task = task
        
        task.expirationHandler = { [weak self] in
            guard let self = self else { return }
            self._expire()
        }
    }
    
    func _expire() {
        self.onExpiredSession.emit()
    }
    
}
