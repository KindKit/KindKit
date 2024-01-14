//
//  KindKit
//

import KindEvent

public final class Clock {
    
    public private(set) var interval: Interval
    public let tolerance: DispatchTimeInterval
    public let queue: DispatchQueue
    public let onStarted = Signal< Void, Void >()
    public let onTriggered = Signal< Void, Void >()
    
    private var _state: State = .paused
    private let _timer: DispatchSourceTimer
    
    public init(
        interval: Interval,
        tolerance: DispatchTimeInterval = .nanoseconds(0),
        queue: DispatchQueue = .main
    ) {
        self.interval = interval
        self.tolerance = tolerance
        self.queue = queue
        self._timer = DispatchSource.makeTimerSource(queue: self.queue)
        self._timer.setEventHandler(handler: { [weak self] in
            guard let self = self else { return }
            if self._timer.isCancelled == false {
                self._fired()
            }
        })
        self._configureTimer()
    }
    
    deinit {
        self._timer.setEventHandler(handler: nil)
        self._timer.cancel()
        switch self._state {
        case .paused, .finished:
            self._timer.resume()
        case .running, .executing:
            break
        }
    }
    
}

public extension Clock {

    @discardableResult
    func fire(
        andPause pause: Bool = false
    ) -> Self {
        self._fired()
        if pause == true {
            return self.pause()
        }
        return self
    }
    
    @discardableResult
    func reset(
        interval: Interval? = nil,
        restart: Bool = true
    ) -> Self {
        if self._state.isRunning == true {
            self._pause(from: self._state)
        }
        if let interval = interval {
            self.interval = interval
        }
        self._reconfigureTimer()
        self._state = .paused
        if restart == true {
            self._timer.resume()
            self._state = .running
            self.onStarted.emit()
        }
        return self
    }

    @discardableResult
    func start() -> Self {
        if self._state.isRunning == false {
            self._timer.resume()
            self._state = .running
            self.onStarted.emit()
        }
        return self
    }

    @discardableResult
    func pause() -> Self {
        switch self._state {
        case .paused, .finished:
            break
        case .running, .executing:
            self._pause(from: self._state)
        }
        return self
    }
    
}

extension Clock : Equatable {
    
    public static func == (lhs: Clock, rhs: Clock) -> Bool {
        return lhs === rhs
    }
    
}

extension Clock : IEntity {
    
    public var isRunning: Bool {
        return self._state.isRunning
    }
    
    public func cancel() {
        self.reset(restart: false)
    }
    
}

private extension Clock {
    
    func _configureTimer() {
        let interval = self.interval.asDispatchTimeInterval
        self._timer.schedule(deadline: .now() + interval, repeating: interval, leeway: self.tolerance)
    }
    
    func _reconfigureTimer() {
        self._timer.cancel()
        self._configureTimer()
    }
    
    @discardableResult
    func _pause(
        from currentState: State,
        to newState: State = .paused
    ) -> Bool {
        guard self._state == currentState else {
            return false
        }
        self._timer.suspend()
        self._state = newState
        return true
    }
    
    func _fired() {
        self._state = .executing
        self.onTriggered.emit()
    }
    
}
