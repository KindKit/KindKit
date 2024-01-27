//
//  KindKit
//

import KindEvent
import KindMeasure

public final class DelayAction : Action {
    
    public private(set) var state: State = .idle {
        didSet {
            switch self.state {
            case .idle:
                break
            case .working:
                self.onStart.emit()
            case .completed:
                self.onFinish.emit(true)
            case .canceled:
                self.onFinish.emit(false)
            }
        }
    }
    
    public private(set) var elapsed: Time
    
    public let duration: Time
    
    public let onStart = Signal< Void, Void >()
    
    public let onFinish = Signal< Void, Bool >()
    
    public init(
        elapsed: Time = .zero,
        duration: Time
    ) {
        self.elapsed = elapsed
        self.duration = duration
    }
    
    public func update(_ interval: Time) -> Result {
        switch self.state {
        case .idle:
            self.state = .working
            fallthrough
        case .working:
            self.elapsed += interval
            if self.elapsed >= self.duration {
                self.state = .completed
                return .completed(self.elapsed - self.duration)
            }
            return .working
        case .completed, .canceled:
            return .completed(interval)
        }
    }
    
    public func complete() {
        switch self.state {
        case .idle, .working:
            self.state = .completed
        case .completed, .canceled:
            break
        }
    }
    
    public func cancel() {
        switch self.state {
        case .idle, .working:
            self.state = .canceled
        case .completed, .canceled:
            break
        }
    }

}
