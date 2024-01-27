//
//  KindKit
//

import KindEvent
import KindMath
import KindTime
import KindMonadicMacro

@KindMonadic
public final class DelayAction : IAction {
    
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
    
    public private(set) var elapsed: SecondsInterval
    
    public let duration: SecondsInterval
    
    public let onStart = Signal< Void, Void >()
    
    public let onFinish = Signal< Void, Bool >()
    
    public init< DurationType : IUnit >(
        duration: Interval< DurationType >
    ) {
        self.elapsed = .zero
        self.duration = .init(duration)
    }
    
    public init< ElapsedType : IUnit, DurationType : IUnit >(
        elapsed: Interval< ElapsedType >,
        duration: Interval< DurationType >
    ) {
        self.elapsed = .init(elapsed)
        self.duration = .init(duration)
    }
    
    public func update(_ interval: SecondsInterval) -> Result {
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
