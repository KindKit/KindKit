//
//  KindKit
//

import Foundation

extension Timer {
    
    public final class Clock {
        
        public private(set) var interval: Timer.Interval
        public let tolerance: DispatchTimeInterval
        public let queue: DispatchQueue
        public let onTriggered: Signal.Args< Void, TimeInterval > = .init()
        
        private var _state: State = .paused
        private let _timer: DispatchSourceTimer
        private var _lastTime: DispatchTime?
        
        public init(
            interval: Timer.Interval,
            tolerance: DispatchTimeInterval = .nanoseconds(0),
            queue: DispatchQueue = .main
        ) {
            self.interval = interval
            self.tolerance = tolerance
            self.queue = queue
            self._timer = DispatchSource.makeTimerSource(queue: self.queue)
            self._configureTimer()
        }
        
        deinit {
            self._timer.setEventHandler(handler: nil)
            self._timer.cancel()
        }
        
    }
    
}

public extension Timer.Clock {
    
    var isRunning: Bool {
        return self._state.isRunning
    }
    
    var isExecuting: Bool {
        return self._state.isExecuting
    }
    
    var isFinished: Bool {
        return self._state.isFinished
    }
    
}

public extension Timer.Clock {
    
    @inlinable
    @discardableResult
    func onTriggered(_ value: (() -> Void)?) -> Self {
        self.onTriggered.link(value)
        return self
    }
    
    @inlinable
    @discardableResult
    func onTriggered(_ value: ((TimeInterval) -> Void)?) -> Self {
        self.onTriggered.link(value)
        return self
    }
    
    @inlinable
    @discardableResult
    func onTriggered(_ closure: @escaping (Self) -> Void) -> Self {
        self.onTriggered.link(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onTriggered(_ closure: @escaping (Self, TimeInterval) -> Void) -> Self {
        self.onTriggered.link(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onTriggered< Sender : AnyObject >(_ sender: Sender, _ closure: @escaping (Sender) -> Void) -> Self {
        self.onTriggered.link(sender, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onTriggered< Sender : AnyObject >(_ sender: Sender, _ closure: @escaping (Sender, TimeInterval) -> Void) -> Self {
        self.onTriggered.link(sender, closure)
        return self
    }
    
}

public extension Timer.Clock {

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
        interval: Timer.Interval? = nil,
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
            self._lastTime = .now()
            self._timer.resume()
            self._state = .running
        }
        return self
    }

    @discardableResult
    func start() -> Self {
        if self._state.isRunning == false {
            if self._state.isFinished == true {
                self.reset(restart: true)
            } else {
                self._lastTime = .now()
                self._timer.resume()
                self._state = .running
            }
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

extension Timer.Clock : Equatable {
    
    public static func == (lhs: Timer.Clock, rhs: Timer.Clock) -> Bool {
        return lhs === rhs
    }
    
}

extension Timer.Clock : ICancellable {
    
    public func cancel() {
        self.reset(restart: false)
    }
    
}

private extension Timer.Clock {
    
    func _configureTimer() {
        let interval = self.interval.asDispatchTimeInterval
        self._timer.schedule(deadline: .now() + interval, repeating: interval, leeway: self.tolerance)
        self._timer.setEventHandler(handler: { [weak self] in
            guard let self = self else { return }
            self._fired()
        })
    }
    
    func _reconfigureTimer() {
        self._timer.setEventHandler(handler: nil)
        self._timer.cancel()
        self._configureTimer()
    }
    
    @discardableResult
    func _pause(
        from currentState: Timer.State,
        to newState: Timer.State = .paused
    ) -> Bool {
        guard self._state == currentState else {
            return false
        }
        self._timer.suspend()
        self._lastTime = nil
        self._state = newState
        return true
    }
    
    func _fired() {
        guard let lastTime = self._lastTime else { return }
        let nextTime = DispatchTime.now()
        self._lastTime = nextTime
        self._state = .executing
        let delta = TimeInterval(nextTime.uptimeNanoseconds - lastTime.uptimeNanoseconds) / 1_000_000_000
        self.onTriggered.emit(delta)

    }
    
}
