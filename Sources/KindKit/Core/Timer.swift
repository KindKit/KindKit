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
        self._impl.onStarted.link(value)
        return self
    }
    
    @discardableResult
    func onStarted(_ closure: @escaping (Self) -> Void) -> Self {
        self._impl.onStarted.link(self, closure)
        return self
    }
    
    @discardableResult
    func onStarted< Sender : AnyObject >(_ sender: Sender, _ closure: @escaping (Sender) -> Void) -> Self {
        self._impl.onStarted.link(sender, closure)
        return self
    }
    
    @discardableResult
    func onRepeat(_ value: (() -> Void)?) -> Self {
        self._impl.onRepeat.link(value)
        return self
    }
    
    @discardableResult
    func onRepeat(_ closure: @escaping (Self) -> Void) -> Self {
        self._impl.onRepeat.link(self, closure)
        return self
    }
    
    @discardableResult
    func onRepeat< Sender : AnyObject >(_ sender: Sender, _ closure: @escaping (Sender) -> Void) -> Self {
        self._impl.onRepeat.link(sender, closure)
        return self
    }
    
    @discardableResult
    func onFinished(_ value: (() -> Void)?) -> Self {
        self._impl.onFinished.link(value)
        return self
    }
    
    @discardableResult
    func onFinished(_ closure: @escaping (Self) -> Void) -> Self {
        self._impl.onFinished.link(self, closure)
        return self
    }
    
    @discardableResult
    func onFinished< Sender : AnyObject >(_ sender: Sender, _ closure: @escaping (Sender) -> Void) -> Self {
        self._impl.onFinished.link(sender, closure)
        return self
    }
    
    @discardableResult
    func onStoped(_ value: (() -> Void)?) -> Self {
        self._impl.onStoped.link(value)
        return self
    }
    
    @discardableResult
    func onStoped(_ closure: @escaping (Self) -> Void) -> Self {
        self._impl.onStoped.link(self, closure)
        return self
    }
    
    @discardableResult
    func onStoped< Sender : AnyObject >(_ sender: Sender, _ closure: @escaping (Sender) -> Void) -> Self {
        self._impl.onStoped.link(sender, closure)
        return self
    }
    
    @discardableResult
    func onPaused(_ value: (() -> Void)?) -> Self {
        self._impl.onPaused.link(value)
        return self
    }
    
    @discardableResult
    func onPaused(_ closure: @escaping (Self) -> Void) -> Self {
        self._impl.onPaused.link(self, closure)
        return self
    }
    
    @discardableResult
    func onPaused< Sender : AnyObject >(_ sender: Sender, _ closure: @escaping (Sender) -> Void) -> Self {
        self._impl.onPaused.link(sender, closure)
        return self
    }
    
    @discardableResult
    func onResumed(_ value: (() -> Void)?) -> Self {
        self._impl.onResumed.link(value)
        return self
    }
    
    @discardableResult
    func onResumed(_ closure: @escaping (Self) -> Void) -> Self {
        self._impl.onResumed.link(self, closure)
        return self
    }
    
    @discardableResult
    func onResumed< Sender : AnyObject >(_ sender: Sender, _ closure: @escaping (Sender) -> Void) -> Self {
        self._impl.onResumed.link(sender, closure)
        return self
    }
    
}

public extension Timer {
    
    @discardableResult
    func start() -> Self {
        self._impl.start()
        return self
    }
    
    @discardableResult
    func stop() -> Self {
        self._impl.stop()
        return self
    }
    
    @discardableResult
    func pause() -> Self {
        self._impl.pause()
        return self
    }
    
    @discardableResult
    func resume() -> Self {
        self._impl.resume()
        return self
    }
    
    @discardableResult
    func restart() -> Self {
        self._impl.restart()
        return self
    }
    
}
