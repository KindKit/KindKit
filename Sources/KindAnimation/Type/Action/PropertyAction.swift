//
//  KindKit
//

import KindEvent
import KindMath
import KindTime
import KindMonadicMacro

@KindMonadic
public final class PropertyAction< Target : AnyObject, Value : ILerpable > : IAction {
    
    public var state: State {
        return self._task.state
    }
    
    public var elapsed: SecondsInterval {
        return self._task.elapsed
    }
    
    public var duration: SecondsInterval {
        return self._task.duration
    }
    
    @KindMonadicProperty
    public var ease: any IEase {
        set { self._task.ease = newValue }
        get { self._task.ease }
    }
    
    public unowned(unsafe) let target: Target
    public let path: ReferenceWritableKeyPath< Target, Value >
    public let from: Value
    public let to: Value
    
    public var onStart: Signal< Void, Void > {
        return self._task.onStart
    }
    
    public var onFinish: Signal< Void, Bool > {
        return self._task.onFinish
    }
    
    private let _task: BlockAction
    
    public init< ElapsedType : IUnit, DurationType : IUnit >(
        elapsed: Interval< ElapsedType >,
        duration: Interval< DurationType >,
        target: Target,
        path: ReferenceWritableKeyPath< Target, Value >,
        to: Value
    ) {
        self.target = target
        self.path = path
        self.from = target[keyPath: path]
        self.to = to
        self._task = .init(
            elapsed: elapsed,
            duration: duration
        )
        
        self._task
            .onProgress(self, { $0._onProgress($1) })
            .onFinish(self, { $0._onFinish($1) })
    }
    
    public convenience init< DurationType : IUnit >(
        duration: Interval< DurationType >,
        target: Target,
        path: ReferenceWritableKeyPath< Target, Value >,
        to: Value
    ) {
        self.init(
            elapsed: Interval< DurationType >.zero,
            duration: duration,
            target: target,
            path: path,
            to: to
        )
    }
    
    public func update(_ interval: SecondsInterval) -> Result {
        return self._task.update(interval)
    }
    
    public func cancel() {
        self._task.cancel()
    }

}

fileprivate extension PropertyAction {
    
    func _onProgress(_ progress: Percent) {
        self.target[keyPath: self.path] = self.from.lerp(self.to, progress: progress)
    }
    
    func _onFinish(_ completion: Bool) {
        self.target[keyPath: self.path] = self.to
    }
    
}
