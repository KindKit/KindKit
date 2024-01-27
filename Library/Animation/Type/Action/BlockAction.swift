//
//  KindKit
//

import KindEvent
import KindMeasure
import KindMonadicMacro

@Monadic
public final class BlockAction : Action {
    
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
    
    public private(set) var elapsed: Time {
        didSet {
            guard self.elapsed != oldValue else { return }
            let progress = (self.elapsed / self.duration).value.clamp(0, 1)
            self.progress = .init(self.ease.perform(progress))
        }
    }
    
    public let duration: Time
    
    public private(set) var progress: Percent = .min {
        didSet {
            guard self.progress != oldValue else { return }
            self.onProgress.emit(self.progress)
        }
    }
    
    @MonadicField
    public var ease: any Ease = LinearEase()
    
    public let onStart = Signal< Void, Void >()
    
    public let onFinish = Signal< Void, Bool >()
    
    @MonadicSignal
    public let onProgress = Signal< Void, Percent >()
    
    public init(
        elapsed: Time = .zero,
        duration: Time
    ) {
        self.elapsed = elapsed
        self.duration = duration
    }
    
    public convenience init< Value : BinaryFloatingPoint >(
        elapsed: Time = .zero,
        distance: Value,
        velocity: Value,
        per: Time
    ) {
        let duration = Time(
            value: Time.Value(distance / velocity),
            unit: per.unit
        )
        self.init(
            elapsed: elapsed,
            duration: duration * per
        )
    }
    
    public convenience init< Value : BinaryFloatingPoint >(
        elapsed: Time = .zero,
        distance: Value,
        velocity: Value,
        progress: Percent,
        per: Time
    ) {
        let duration = Time(
            value: Time.Value(distance / velocity),
            unit: per.unit
        )
        self.init(
            elapsed: duration * progress * per,
            duration: duration * per
        )
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
    
    public func cancel() {
        switch self.state {
        case .idle, .working:
            self.state = .canceled
        case .completed, .canceled:
            break
        }
    }

}
