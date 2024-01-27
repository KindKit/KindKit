//
//  KindKit
//

import Foundation
import KindEvent
import KindTime

public final class Once< UnitType : IUnit > {
    
    public private(set) var interval: Interval< UnitType >
    public let tolerance: Interval< UnitType >
    public let queue: DispatchQueue
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
            timer.schedule(deadline: .now() + interval, leeway: self.tolerance.dispatchTimeInterval)
        }
    }
    
    public init(
        interval: Interval< UnitType >,
        tolerance: Interval< UnitType > = .zero,
        queue: DispatchQueue = .main
    ) {
        self.interval = interval
        self.tolerance = tolerance
        self.queue = queue
    }
    
    deinit {
        self._reset()
    }
    
}

public extension Once {

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
        interval: Interval< UnitType >? = nil,
        restart: Bool = true
    ) -> Self {
        if self._state.isRunning == true {
            self._reset()
        }
        if let interval = interval {
            self.interval = interval
        }
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

extension Once : Equatable {
    
    public static func == (lhs: Once, rhs: Once) -> Bool {
        return lhs === rhs
    }
    
}

extension Once : IEntity {
    
    public var isRunning: Bool {
        return self._state.isRunning
    }
    
    public func cancel() {
        self.reset(restart: false)
    }
    
}

extension Once : IEndable {
    
    public var isFinished: Bool {
        return self._state.isFinished
    }
    
}

private extension Once {
    
    func _reset() {
        self._timer = nil
    }
    
    func _fired() {
        self._state = .executing
        self.onTriggered.emit()
        self._state = .finished
        self._reset()
        self.onFinished.emit()
    }
    
}
