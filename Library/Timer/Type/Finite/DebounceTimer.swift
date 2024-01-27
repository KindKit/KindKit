//
//  KindKit
//

import Foundation
import KindEvent
import KindMeasure

public final class DebounceTimer : FiniteTimer {
    
    public var queue: DispatchQueue {
        return self._timer.queue
    }
    
    public var isRunning: Bool {
        return self._timer.isRunning
    }
    
    public var onStarted: Signal< Void, Void > {
        return self._timer.onStarted
    }
    
    public var onTriggered: Signal< Void, Void > {
        return self._timer.onTriggered
    }
    
    public var isFinished: Bool {
        return self._timer.isFinished
    }
    
    public var onFinished: Signal< Void, Void > {
        return self._timer.onFinished
    }
    
    private let _timer: OnceTimer
    
    public init(
        tolerance: Time = .zero,
        delay: Time,
        queue: DispatchQueue = .main
    ) {
        self._timer = .init(
            tolerance: tolerance,
            interval: delay,
            queue: queue
        )
    }
    
    public func cancel() {
        self._timer.cancel()
    }
    
}

public extension DebounceTimer {
    
    var delay: Time {
        set { self._timer.reset(interval: newValue, restart: self._timer.isRunning) }
        get { self._timer.interval }
    }
    
    var tolerance: Time {
        return self._timer.tolerance
    }
    
    func emit() -> Self {
        if self._timer.isFinished == false {
            self._timer.reset(restart: true)
        } else if self._timer.isRunning == false {
            self._timer.start()
        }
        return self
    }
    
}
