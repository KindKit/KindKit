//
//  KindKit
//

import Foundation
import KindEvent
import KindMeasure

public final class EveryTimer : FiniteTimer {
    
    public var isRunning: Bool {
        return self._state.isRunning
    }
    
    public var isFinished: Bool {
        return self._state.isFinished
    }
    
    public let tolerance: Time
    
    public private(set) var interval: Time
    
    public let queue: DispatchQueue
    
    public private(set) var iterations: Int
    
    public private(set) var remainings: Int = 0
    
    public let onStarted = Signal< Void, Void >()
    
    public let onTriggered = Signal< Void, Void >()
    
    public let onFinished = Signal< Void, Void >()
    
    var timer: DispatchSourceTimer {
        if let timer = self._timer {
            return timer
        }
        let timer = DispatchSource.makeTimerSource(queue: self.queue)
        self._timer = timer
        return timer
    }
    
    private var _state: State = .paused
    private var _timer: DispatchSourceTimer? {
        willSet {
            guard let timer = self._timer else { return }
            timer.setEventHandler(handler: nil)
            timer.cancel()
            switch self._state {
            case .paused, .finished:
                timer.resume()
            case .running, .executing:
                break
            }
        }
        didSet {
            guard let timer = self._timer else { return }
            let interval = self.interval.dispatchTimeInterval
            timer.setEventHandler(handler: { [weak self] in
                guard let self = self else { return }
                self._fired()
            })
            timer.schedule(deadline: .now() + interval, repeating: interval, leeway: self.tolerance.dispatchTimeInterval)
        }
    }
    
    public init(
        tolerance: Time = .zero,
        interval: Time,
        iterations: Int,
        queue: DispatchQueue = .main
    ) {
        self.tolerance = tolerance
        self.interval = interval
        self.iterations = iterations
        self.remainings = iterations
        self.queue = queue
    }
    
    deinit {
        self._reset()
    }
    
    public func cancel() {
        self.reset(restart: false)
    }
    
}

public extension EveryTimer {

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
        interval: Time? = nil,
        iterations: Int? = nil,
        restart: Bool = true
    ) -> Self {
        if self._state.isRunning == true {
            self._reset()
        }
        if let interval = interval {
            self.interval = interval
        }
        if let iterations = iterations {
            self.iterations = iterations
        }
        self.remainings = self.iterations
        self._state = .paused
        if restart == true {
            self.timer.resume()
            self._state = .running
            self.onStarted.emit()
        }
        return self
    }

    @discardableResult
    func start() -> Self {
        if self._state.isRunning == false {
            self.timer.resume()
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
            self.timer.suspend()
            self._state = .paused
        }
        return self
    }
    
}

private extension EveryTimer {
    
    func _reset() {
        self._timer = nil
    }
    
    func _fired() {
        self._state = .executing
        self.remainings -= 1
        self.onTriggered.emit()
        if self.remainings == 0 {
            self._state = .finished
            self._reset()
            self.onFinished.emit()
        }
    }
    
}
