//
//  DSCore
//

#if os(iOS)

import UIKit
import KindEvent

public extension Manager.BackgroundTask {
    
    final class Real : IBackgroundManager {
        
        public let observer = Observer< IBackgroundManagerObserver >()
        
        private var _counter: UInt
        private var _task: UIBackgroundTaskIdentifier
        
        public init() {
            self._counter = 0
            self._task = .invalid
        }
        
        deinit {
            self._stop()
        }
        
        public func start() {
            self._counter += 1
            if self._counter == 1 {
                self._task = UIApplication.shared.beginBackgroundTask(
                    expirationHandler: { [weak self] in self?._expire() }
                )
            }
        }
        
        public func stop() {
            if self._counter == 0 {
                return
            }
            self._counter -= 1
            if self._counter == 0 {
                self._stop()
            }
        }
        
    }
    
}

private extension Manager.BackgroundTask.Real {
    
    func _stop() {
        if self._task != .invalid {
            UIApplication.shared.endBackgroundTask(self._task)
            self._task = .invalid
        }
    }
    
    func _expire() {
        self._counter = 0
        self._task = .invalid
        self.observer.emit({ $0.expiredSession(self) })
    }
    
}

public extension IBackgroundManager where Self == Manager.BackgroundTask.Real {
    
    static func real() -> Self {
        return .init()
    }
    
}

#endif
