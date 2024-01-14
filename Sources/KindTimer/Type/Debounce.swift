//
//  KindKit
//

import KindEvent

public final class Debounce {
    
    private let _timer: Once
    
    public init(
        delay: Interval,
        tolerance: DispatchTimeInterval = .nanoseconds(0),
        queue: DispatchQueue = .main
    ) {
        self._timer = Once(
            interval: delay,
            tolerance: tolerance,
            queue: queue
        )
    }
    
}

public extension Debounce {
    
    var delay: Interval {
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

extension Debounce : Equatable {
    
    public static func == (lhs: Debounce, rhs: Debounce) -> Bool {
        return lhs === rhs
    }
    
}

extension Debounce : IEntity {
    
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
    
    public func cancel() {
        self._timer.cancel()
    }
    
}

extension Debounce : IEndable {
    
    public var isFinished: Bool {
        return self._timer.isFinished
    }
    
    public var onFinished: Signal< Void, Void > {
        return self._timer.onFinished
    }
    
}
