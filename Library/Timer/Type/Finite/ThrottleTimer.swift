//
//  KindKit
//

import Foundation
import KindEvent
import KindMeasure

public final class ThrottleTimer : FiniteTimer {
    
    public var isRunning: Bool {
        return self._task != nil
    }
    
    public var isFinished: Bool {
        return self._task == nil
    }
    
    public let mode: Mode
    
    public private(set) var interval: Time
    
    public private(set) var immediateFire: Bool
    
    public let queue: DispatchQueue
    
    public let onStarted = Signal< Void, Void >()
    
    public let onTriggered = Signal< Void, Void >()
    
    public let onFinished = Signal< Void, Void >()
    
    private var _previousScheduled: DispatchTime?
    
    private var _lastExecutionTime: DispatchTime?
    
    private var _waitingForPerform: Bool = false
    
    private var _task: DispatchWorkItem? {
        willSet { self._task?.cancel() }
    }
    
    public init(
        mode: Mode = .fixed,
        interval: Time,
        immediateFire: Bool = false,
        queue: DispatchQueue = .main
    ) {
        self.mode = mode
        self.interval = interval
        self.immediateFire = immediateFire
        self.queue = queue
    }
    
    public func cancel() {
        self._previousScheduled = nil
        self._lastExecutionTime = nil
        self._waitingForPerform = false
        self._task?.cancel()
        self._task = nil
    }
    
}

public extension ThrottleTimer {
    
    @discardableResult
    func emit() -> Self {
        if self._task == nil {
            self.onStarted.emit()
        }
        self._task = DispatchWorkItem(block: { [weak self] in
            guard let self = self else { return }
            self._lastExecutionTime = .now()
            self._waitingForPerform = false
            self._task = nil
            self.onTriggered.emit()
            if let previousScheduled = self._previousScheduled, let lastExecutionTime = self._lastExecutionTime {
                if previousScheduled < lastExecutionTime {
                    self.onFinished.emit()
                }
            }
        })
        let now = DispatchTime.now()
        let deadline = self._resolveDeadline(now)
        self._previousScheduled = now
        self._waitingForPerform = true
        self.queue.asyncAfter(
            deadline: deadline,
            execute: self._task!
        )
        return self
    }
    
}

private extension ThrottleTimer {
    
    func _resolveDeadline(_ now: DispatchTime) -> DispatchTime {
        let interval = self.interval.dispatchTimeInterval
        switch self.mode {
        case .fixed:
            if let lastExecutionTime = self._lastExecutionTime {
                let time = lastExecutionTime + interval
                if time > now {
                    return time
                }
            }
            if self._waitingForPerform == true {
                if let previous = self._previousScheduled {
                    if previous > now {
                        return previous
                    }
                }
            } else if self.immediateFire == false {
                return now + interval
            }
        case .deferred:
            if let lastExecutionTime = self._lastExecutionTime {
                let time = lastExecutionTime + interval
                if time > now {
                    return time
                }
            }
            if self._waitingForPerform == true && self.immediateFire == false {
                return now + interval
            }
        }
        return now
    }
    
}
