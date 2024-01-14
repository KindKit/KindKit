//
//  KindKit
//

import KindEvent

public final class Throttle {
    
    public let mode: Mode
    public private(set) var interval: DispatchTimeInterval
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
        interval: Interval,
        immediateFire: Bool = false,
        queue: DispatchQueue = .main
    ) {
        self.mode = mode
        self.interval = interval.asDispatchTimeInterval
        self.immediateFire = immediateFire
        self.queue = queue
    }
    
}

public extension Throttle {
    
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

extension Throttle : Equatable {
    
    public static func == (lhs: Throttle, rhs: Throttle) -> Bool {
        return lhs === rhs
    }
    
}

extension Throttle : IEntity {
    
    public var isRunning: Bool {
        return self._task != nil
    }
    
    public func cancel() {
        self._previousScheduled = nil
        self._lastExecutionTime = nil
        self._waitingForPerform = false
        self._task?.cancel()
        self._task = nil
    }
    
}

extension Throttle : IEndable {
    
    public var isFinished: Bool {
        return self._task == nil
    }
    
}

private extension Throttle {
    
    func _resolveDeadline(_ now: DispatchTime) -> DispatchTime {
        switch self.mode {
        case .fixed:
            if let lastExecutionTime = self._lastExecutionTime {
                let time = lastExecutionTime + self.interval
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
                return now + self.interval
            }
        case .deferred:
            if let lastExecutionTime = self._lastExecutionTime {
                let time = lastExecutionTime + self.interval
                if time > now {
                    return time
                }
            }
            if self._waitingForPerform == true && self.immediateFire == false {
                return now + self.interval
            }
        }
        return now
    }
    
}
