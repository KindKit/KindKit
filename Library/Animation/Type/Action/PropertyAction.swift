//
//  KindKit
//

import KindEvent
import KindMeasure
import KindMonadicMacro

@Monadic
public final class PropertyAction< Target : AnyObject, Value : LerpTrait > : Action {
    
    public var state: State {
        return self._task.state
    }
    
    public var elapsed: Time {
        return self._task.elapsed
    }
    
    public var duration: Time {
        return self._task.duration
    }
    
    @MonadicField
    public var ease: any Ease {
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
    
    public init(
        elapsed: Time = .zero,
        duration: Time,
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
            .onProgress(target: self, regular: { $0._onProgress($1) })
            .onFinish(target: self, regular: { $0._onFinish($1) })
    }
    
    public func update(_ interval: Time) -> Result {
        return self._task.update(interval)
    }
    
    public func cancel() {
        self._task.cancel()
    }

}

fileprivate extension PropertyAction {
    
    func _onProgress(_ progress: Percent) {
        self.target[keyPath: self.path] = self.from.lerp(self.to, by: progress)
    }
    
    func _onFinish(_ completion: Bool) {
        self.target[keyPath: self.path] = self.to
    }
    
}
