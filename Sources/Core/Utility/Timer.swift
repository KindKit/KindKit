//
//  KindKitCore
//

import Foundation
#if os(iOS)
import UIKit
#endif

public final class Timer : NSObject {

    public private(set) var interval: TimeInterval
    public private(set) var delay: TimeInterval
    public private(set) var repeating: UInt
    public private(set) var isDelaying: Bool
    public private(set) var isStarted: Bool
    public private(set) var isPaused: Bool
    public private(set) var repeated: UInt

    private var _onStarted: (() -> Void)?
    private var _onRepeat: (() -> Void)?
    private var _onFinished: (() -> Void)?
    private var _onStoped: (() -> Void)?
    private var _onPaused: (() -> Void)?
    private var _onResumed: (() -> Void)?

    private var _startDelayDate: Date?
    private var _startDate: Date?
    private var _pauseDate: Date?
    private var _timer: Foundation.Timer?

    public init(
        interval: TimeInterval,
        delay: TimeInterval = 0,
        repeating: UInt = 0
    ) {
        self.interval = interval
        self.delay = delay
        self.repeating = repeating
        self.isDelaying = false
        self.isStarted = false
        self.isPaused = false
        self.repeated = 0
        super.init()
        self._subsribe()
    }
    
    deinit {
        self._unsubsribe()
    }
    
    @discardableResult
    public func onStarted(_ value: (() -> Void)?) -> Self {
        self._onStarted = value
        return self
    }
    
    @discardableResult
    public func onRepeat(_ value: (() -> Void)?) -> Self {
        self._onRepeat = value
        return self
    }
    
    @discardableResult
    public func onFinished(_ value: (() -> Void)?) -> Self {
        self._onFinished = value
        return self
    }
    
    @discardableResult
    public func onStoped(_ value: (() -> Void)?) -> Self {
        self._onStoped = value
        return self
    }
    
    @discardableResult
    public func onPaused(_ value: (() -> Void)?) -> Self {
        self._onPaused = value
        return self
    }
    
    @discardableResult
    public func onResumed(_ value: (() -> Void)?) -> Self {
        self._onResumed = value
        return self
    }
    
    @discardableResult
    public func start() -> Self {
        if self.isStarted == false {
            self.isStarted = true
            self.isPaused = false
            if self.delay > TimeInterval.ulpOfOne {
                self._startDate = Date() + self.delay
                self.isDelaying = true
            } else {
                self._startDate = Date() + self.interval
                self.isDelaying = false
            }
            self._pauseDate = nil
            self.repeated = 0
            self._timer = Foundation.Timer(
                fireAt: self._startDate!,
                interval: self.interval,
                target: self,
                selector: #selector(self._handler(_:)),
                userInfo: nil,
                repeats: (self.isDelaying == true) || (self.repeating != 0)
            )
            if self.isDelaying == false {
                self._onStarted?()
            }
            RunLoop.main.add(self._timer!, forMode: RunLoop.Mode.common)
        }
        return self
    }
    
    @discardableResult
    public func stop() -> Self {
        if self.isStarted == true {
            self.isDelaying = false
            self.isStarted = false
            self.isPaused = false
            self._startDate = nil
            self._pauseDate = nil
            self.repeated = 0
            self._timer?.invalidate()
            self._timer = nil
            self._onStoped?()
        }
        return self
    }
    
    @discardableResult
    public func pause() -> Self {
        if (self.isStarted == true) && (self.isPaused == false) {
            self.isPaused = true
            self._pauseDate = Date()
            self._timer?.invalidate()
            self._timer = nil
            self._onPaused?()
        }
        return self
    }
    
    @discardableResult
    public func resume() -> Self {
        if (self.isStarted == true) && (self.isPaused == true) {
            self.isPaused = false
            self._startDate = self._startDate! + (Date().timeIntervalSince1970 - self._pauseDate!.timeIntervalSince1970)
            self._pauseDate = nil;
            self._timer = Foundation.Timer(
                fireAt: self._startDate!,
                interval: self.interval,
                target: self,
                selector: #selector(self._handler(_:)),
                userInfo: nil,
                repeats: (self.repeating != 0)
            )
            self._onResumed?()
            RunLoop.main.add(self._timer!, forMode: RunLoop.Mode.common)
        }
        return self
    }
    
    @discardableResult
    public func restart() -> Self {
        self.stop()
        self.start()
        return self
    }
    
}

private extension Timer {
    
    func _subsribe() {
        #if os(iOS)
        NotificationCenter.default.addObserver(self, selector: #selector(self._didEnterBackground(_:)), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self._willEnterForeground(_:)), name: UIApplication.willEnterForegroundNotification, object: nil)
        #endif
    }
    
    func _unsubsribe() {
        #if os(iOS)
        NotificationCenter.default.removeObserver(self, name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.willEnterForegroundNotification, object: nil)
        #endif
    }
    
    @objc
    func _didEnterBackground(_ notification: Notification) {
        self.pause()
    }
    
    @objc
    func _willEnterForeground(_ notification: Notification) {
        self.resume()
    }

    @objc
    func _handler(_ sender: Any) {
        if self.isDelaying == true {
            self.isDelaying = false
            self._onStarted?()
        } else {
            var finished = false
            self.repeated += 1
            if self.repeating == UInt.max {
                self._onRepeat?()
            } else if self.repeated != 0 {
                self._onRepeat?()
                if self.repeated >= self.repeating {
                    finished = true
                }
            } else {
                finished = true
            }
            if finished == true {
                self.isStarted = false
                self.isPaused = false
                self._timer?.invalidate()
                self._timer = nil
                self._onFinished?()
            }
        }
    }

}
