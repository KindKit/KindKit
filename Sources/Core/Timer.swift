//
//  KindKit
//

import Foundation

public final class Timer {

    public var interval: TimeInterval {
        return self._impl.interval
    }
    public var delay: TimeInterval {
        return self._impl.delay
    }
    public var repeating: UInt {
        return self._impl.repeating
    }
    public var isDelaying: Bool {
        return self._impl.isDelaying
    }
    public var isStarted: Bool {
        return self._impl.isStarted
    }
    public var isPaused: Bool {
        return self._impl.isPaused
    }
    public var repeated: UInt {
        return self._impl.repeated
    }
    
    private var _impl: Timer.Impl

    public init(
        interval: TimeInterval,
        delay: TimeInterval = 0,
        repeating: UInt = 0
    ) {
        self._impl = .init(
            interval: interval,
            delay: delay,
            repeating: repeating
        )
    }
    
    deinit {
        self._impl.stop()
    }
    
    @discardableResult
    public func onStarted(_ value: (() -> Void)?) -> Self {
        self._impl.onStarted(value)
        return self
    }
    
    @discardableResult
    public func onRepeat(_ value: (() -> Void)?) -> Self {
        self._impl.onRepeat(value)
        return self
    }
    
    @discardableResult
    public func onFinished(_ value: (() -> Void)?) -> Self {
        self._impl.onFinished(value)
        return self
    }
    
    @discardableResult
    public func onStoped(_ value: (() -> Void)?) -> Self {
        self._impl.onStoped(value)
        return self
    }
    
    @discardableResult
    public func onPaused(_ value: (() -> Void)?) -> Self {
        self._impl.onPaused(value)
        return self
    }
    
    @discardableResult
    public func onResumed(_ value: (() -> Void)?) -> Self {
        self._impl.onResumed(value)
        return self
    }
    
    @discardableResult
    public func start() -> Self {
        self._impl.start()
        return self
    }
    
    @discardableResult
    public func stop() -> Self {
        self._impl.stop()
        return self
    }
    
    @discardableResult
    public func pause() -> Self {
        self._impl.pause()
        return self
    }
    
    @discardableResult
    public func resume() -> Self {
        self._impl.resume()
        return self
    }
    
    @discardableResult
    public func restart() -> Self {
        self._impl.restart()
        return self
    }
    
}
