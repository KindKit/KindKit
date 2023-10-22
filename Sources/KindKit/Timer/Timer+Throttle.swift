//
//  KindKit
//

import Foundation

extension Timer {
    
    public final class Throttle {
        
        public let mode: Mode
        public private(set) var interval: DispatchTimeInterval
        public private(set) var immediateFire: Bool
        public let queue: DispatchQueue
        
        public let onStarted = Signal.Empty< Void >()
        public let onTriggered = Signal.Empty< Void >()
        public let onFinished = Signal.Empty< Void >()
        
        private var _previousScheduled: DispatchTime?
        private var _lastExecutionTime: DispatchTime?
        private var _waitingForPerform: Bool = false
        private var _task: DispatchWorkItem?
        
        public init(
            mode: Mode = .fixed,
            interval: Timer.Interval,
            immediateFire: Bool = false,
            queue: DispatchQueue = .main
        ) {
            self.mode = mode
            self.interval = interval.asDispatchTimeInterval
            self.immediateFire = immediateFire
            self.queue = queue
        }
        
    }
    
}

public extension Timer.Throttle {
    
    func emit() {
        if let task = self._task {
            task.cancel()
        } else {
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
        self._previousScheduled = .now()
        self._waitingForPerform = true
        self.queue.asyncAfter(
            deadline: self._resolveDeadline(self._previousScheduled!),
            execute: self._task!
        )
    }
    
}

extension Timer.Throttle : Equatable {
    
    public static func == (lhs: Timer.Throttle, rhs: Timer.Throttle) -> Bool {
        return lhs === rhs
    }
    
}

extension Timer.Throttle : ITimerWithEnding {
    
    public var isRunning: Bool {
        return self._task != nil
    }
    
    public var isFinished: Bool {
        return self._task == nil
    }
    
    public func cancel() {
        self._previousScheduled = nil
        self._lastExecutionTime = nil
        self._waitingForPerform = false
        self._task?.cancel()
        self._task = nil
    }
    
}

private extension Timer.Throttle {
    
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
