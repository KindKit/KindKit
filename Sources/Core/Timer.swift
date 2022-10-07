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
    
}

public extension Timer {
    
    @discardableResult
    func onStarted(_ value: (() -> Void)?) -> Self {
        self._impl.onStarted.set(value)
        return self
    }
    
    @discardableResult
    func onStarted(_ closure: ((Self) -> Void)?) -> Self {
        self._impl.onStarted.set(self, closure)
        return self
    }
    
    @discardableResult
    func onStarted< Sender : AnyObject >(_ sender: Sender, _ closure: ((Sender) -> Void)?) -> Self {
        self._impl.onStarted.set(sender, closure)
        return self
    }
    
    @discardableResult
    func onRepeat(_ value: (() -> Void)?) -> Self {
        self._impl.onRepeat.set(value)
        return self
    }
    
    @discardableResult
    func onRepeat(_ closure: ((Self) -> Void)?) -> Self {
        self._impl.onRepeat.set(self, closure)
        return self
    }
    
    @discardableResult
    func onRepeat< Sender : AnyObject >(_ sender: Sender, _ closure: ((Sender) -> Void)?) -> Self {
        self._impl.onRepeat.set(sender, closure)
        return self
    }
    
    @discardableResult
    func onFinished(_ value: (() -> Void)?) -> Self {
        self._impl.onFinished.set(value)
        return self
    }
    
    @discardableResult
    func onFinished(_ closure: ((Self) -> Void)?) -> Self {
        self._impl.onFinished.set(self, closure)
        return self
    }
    
    @discardableResult
    func onFinished< Sender : AnyObject >(_ sender: Sender, _ closure: ((Sender) -> Void)?) -> Self {
        self._impl.onFinished.set(sender, closure)
        return self
    }
    
    @discardableResult
    func onStoped(_ value: (() -> Void)?) -> Self {
        self._impl.onStoped.set(value)
        return self
    }
    
    @discardableResult
    func onStoped(_ closure: ((Self) -> Void)?) -> Self {
        self._impl.onStoped.set(self, closure)
        return self
    }
    
    @discardableResult
    func onStoped< Sender : AnyObject >(_ sender: Sender, _ closure: ((Sender) -> Void)?) -> Self {
        self._impl.onStoped.set(sender, closure)
        return self
    }
    
    @discardableResult
    func onPaused(_ value: (() -> Void)?) -> Self {
        self._impl.onPaused.set(value)
        return self
    }
    
    @discardableResult
    func onPaused(_ closure: ((Self) -> Void)?) -> Self {
        self._impl.onPaused.set(self, closure)
        return self
    }
    
    @discardableResult
    func onPaused< Sender : AnyObject >(_ sender: Sender, _ closure: ((Sender) -> Void)?) -> Self {
        self._impl.onPaused.set(sender, closure)
        return self
    }
    
    @discardableResult
    func onResumed(_ value: (() -> Void)?) -> Self {
        self._impl.onResumed.set(value)
        return self
    }
    
    @discardableResult
    func onResumed(_ closure: ((Self) -> Void)?) -> Self {
        self._impl.onResumed.set(self, closure)
        return self
    }
    
    @discardableResult
    func onResumed< Sender : AnyObject >(_ sender: Sender, _ closure: ((Sender) -> Void)?) -> Self {
        self._impl.onResumed.set(sender, closure)
        return self
    }
    
}

public extension Timer {
    
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
