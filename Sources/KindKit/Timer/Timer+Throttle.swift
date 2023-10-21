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
        
        public let onTriggered: Signal.Empty< Void > = .init()
        
        private var _task: DispatchWorkItem?
        private var _previousScheduled: DispatchTime?
        private var _lastExecutionTime: DispatchTime?
        private var _waitingForPerform: Bool = false
        
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
        }
        let task = DispatchWorkItem(block: { [weak self] in
            guard let self = self else { return }
            self._lastExecutionTime = .now()
            self._waitingForPerform = false
            self.onTriggered.emit()
        })
        self._task = task
        let now = DispatchTime.now()
        self._previousScheduled = now
        self._waitingForPerform = true
        self.queue.asyncAfter(
            deadline: self._resolveDeadline(now),
            execute: task
        )
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
                let time = (lastExecutionTime + self.interval)
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

extension Timer.Throttle : Equatable {
    
    public static func == (lhs: Timer.Throttle, rhs: Timer.Throttle) -> Bool {
        return lhs === rhs
    }
    
}
