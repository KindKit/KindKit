//
//  KindKit
//

import Foundation

extension Timer {
    
    public final class Debounce {
        
        public let onTriggered: Signal.Empty< Void > = .init()
        
        private let _timer: Timer.Once
        
        public init(
            delay: Timer.Interval,
            tolerance: DispatchTimeInterval = .nanoseconds(0),
            queue: DispatchQueue = .main
        ) {
            self._timer = Timer.Once(
                interval: delay,
                tolerance: tolerance,
                queue: queue
            )
            
            self._timer.onTriggered(self, { $0.onTriggered.emit() })
        }
        
    }
    
}

public extension Timer.Debounce {
    
    var delay: Timer.Interval {
        set { self._timer.reset(interval: newValue, restart: self._timer.isRunning) }
        get { self._timer.interval }
    }
    
    var isRunning: Bool {
        return self._timer.isRunning
    }
    
    var isFinished: Bool {
        return self._timer.isFinished
    }
    
}

public extension Timer.Debounce {
    
    @discardableResult
    func onTriggered(_ value: (() -> Void)?) -> Self {
        self.onTriggered.link(value)
        return self
    }
    
    @discardableResult
    func onTriggered(_ closure: @escaping (Self) -> Void) -> Self {
        self.onTriggered.link(self, closure)
        return self
    }
    
    @discardableResult
    func onTriggered< Sender : AnyObject >(_ sender: Sender, _ closure: @escaping (Sender) -> Void) -> Self {
        self.onTriggered.link(sender, closure)
        return self
    }
    
}

public extension Timer.Debounce {
    
    func emit() -> Self {
        if self._timer.isFinished == false {
            self._timer.reset(restart: true)
        } else if self._timer.isRunning == false {
            self._timer.start()
        }
        return self
    }
    
}

extension Timer.Debounce : Equatable {
    
    public static func == (lhs: Timer.Debounce, rhs: Timer.Debounce) -> Bool {
        return lhs === rhs
    }
    
}

extension Timer.Debounce : ICancellable {
    
    public func cancel() {
        self._timer.cancel()
    }
    
}
