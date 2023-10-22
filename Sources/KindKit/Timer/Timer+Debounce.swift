//
//  KindKit
//

import Foundation

extension Timer {
    
    public final class Debounce {
        
        private let _timer: Timer.Once
        
        public init(
            delay: Timer.Interval,
            tolerance: DispatchTimeInterval = .nanoseconds(0),
            queue: DispatchQueue = .main
        ) {
            self._timer = Timer.Once(
                interval: delay,
                tolerance: tolerance,
                queue: queue
            )
        }
        
    }
    
}

public extension Timer.Debounce {
    
    var delay: Timer.Interval {
        set { self._timer.reset(interval: newValue, restart: self._timer.isRunning) }
        get { self._timer.interval }
    }
    
    var tolerance: DispatchTimeInterval {
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

extension Timer.Debounce : Equatable {
    
    public static func == (lhs: Timer.Debounce, rhs: Timer.Debounce) -> Bool {
        return lhs === rhs
    }
    
}

extension Timer.Debounce : ITimerWithEnding {
    
    public var queue: DispatchQueue {
        return self._timer.queue
    }
    
    public var isRunning: Bool {
        return self._timer.isRunning
    }
    
    public var isFinished: Bool {
        return self._timer.isFinished
    }
    
    public var onStarted: Signal.Empty< Void > {
        return self._timer.onStarted
    }
    
    public var onTriggered: Signal.Empty< Void > {
        return self._timer.onTriggered
    }
    
    public var onFinished: Signal.Empty< Void > {
        return self._timer.onFinished
    }
    
    public func cancel() {
        self._timer.cancel()
    }
    
}
