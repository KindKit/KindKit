//
//  KindKit
//

import KindEvent
import KindMath
import KindTime
import KindMonadicMacro

@KindMonadic
public final class BlockAction : IAction {
    
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
    
    public private(set) var elapsed: SecondsInterval {
        didSet {
            guard self.elapsed != oldValue else { return }
            let progress = (self.elapsed / self.duration).value.clamp(0, 1)
            self.progress = .init(self.ease.perform(progress))
        }
    }
    
    public let duration: SecondsInterval
    
    public private(set) var progress: Percent = .zero {
        didSet {
            guard self.progress != oldValue else { return }
            self.onProgress.emit(self.progress)
        }
    }
    
    @KindMonadicProperty
    public var ease: any IEase = LinearEase()
    
    public let onStart = Signal< Void, Void >()
    
    public let onFinish = Signal< Void, Bool >()
    
    @KindMonadicSignal
    public let onProgress = Signal< Void, Percent >()
    
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
    
    public convenience init< ValueType : BinaryFloatingPoint, UnitType : IUnit >(
        distance: ValueType,
        velocity: ValueType,
        per: Interval< UnitType >
    ) {
        self.init(
            duration: Interval< UnitType >(distance / velocity) * per
        )
    }
    
    public convenience init< ValueType : BinaryFloatingPoint, UnitType : IUnit >(
        distance: ValueType,
        velocity: ValueType,
        progress: Percent,
        per: Interval< UnitType >
    ) {
        let duration = distance / velocity
        self.init(
            elapsed: Interval< UnitType >(Double(duration) * progress.value) * per,
            duration: Interval< UnitType >(duration) * per
        )
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
    
    public func cancel() {
        switch self.state {
        case .idle, .working:
            self.state = .canceled
        case .completed, .canceled:
            break
        }
    }

}
