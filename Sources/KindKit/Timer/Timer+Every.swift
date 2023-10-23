//
//  KindKit
//

import Foundation

extension Timer {
    
    public final class Every {
        
        public private(set) var interval: Timer.Interval
        public let tolerance: DispatchTimeInterval
        public let queue: DispatchQueue
        public private(set) var iterations: Int
        public private(set) var remainings: Int = 0
        public let onStarted = Signal.Empty< Void >()
        public let onTriggered = Signal.Empty< Void >()
        public let onFinished = Signal.Empty< Void >()
        
        private var _state: State = .paused
        private let _timer: DispatchSourceTimer
        
        public init(
            interval: Timer.Interval,
            iterations: Int,
            tolerance: DispatchTimeInterval = .nanoseconds(0),
            queue: DispatchQueue = .main
        ) {
            self.interval = interval
            self.iterations = iterations
            self.remainings = iterations
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
    
}

public extension Timer.Every {

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
        iterations: Int? = nil,
        restart: Bool = true
    ) -> Self {
        if self._state.isRunning == true {
            self._pause(from: self._state)
        }
        if let interval = interval {
            self.interval = interval
        }
        if let iterations = iterations {
            self.iterations = iterations
        }
        self.remainings = self.iterations
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

extension Timer.Every : Equatable {
    
    public static func == (lhs: Timer.Every, rhs: Timer.Every) -> Bool {
        return lhs === rhs
    }
    
}

extension Timer.Every : ITimerWithEnding {
    
    public var isRunning: Bool {
        return self._state.isRunning
    }
    
    public var isFinished: Bool {
        return self._state.isFinished
    }
    
    public func cancel() {
        self.reset(restart: false)
    }
    
}

private extension Timer.Every {
    
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
        from currentState: Timer.State,
        to newState: Timer.State = .paused
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
        self.remainings -= 1
        self.onTriggered.emit()
        if self.remainings == 0 {
            self._pause(from: .executing, to: .finished)
            self.onFinished.emit()
        }
    }
    
}
