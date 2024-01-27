//
//  KindKit
//

import Dispatch
import KindCore
import KindMeasure

public final class DelayOperator< Value : ResultTrait > : Operator {
    
    public typealias Input = Value
    public typealias Output = Value
    public typealias Timeout = @Sendable (InputState) -> Time
    
    private let _lock = RecursiveLock()
    private let _dispatch: DispatchQueue
    private let _timeout: Timeout
    private var _queue: [InputState] = []
    private var _task: CancelTrait?
    private var _next: (any Pipe)!
    
    fileprivate init(
        _ dispatch: DispatchQueue,
        _ timeout: @escaping Timeout
    ) {
        self._dispatch = dispatch
        self._timeout = timeout
    }
    
    deinit {
        self._task?.cancel()
    }
    
    public func connect(next: any Pipe) {
        self._next = next
    }
    
    public func receive(_ state: InputState) {
        self._lock.perform({
            if state.isCanceled {
                if let task = self._task {
                    task.cancel()
                    self._task = nil
                }
                self._queue.removeAll(keepingCapacity: true)
                self._task = DispatchWorkItem.async(
                    queue: self._dispatch,
                    block: { [weak self] in
                        guard let self = self else { return }
                        self._cancel()
                    }
                )
            } else {
                self._queue.append(state)
                if self._task == nil {
                    self._task = DispatchWorkItem.async(
                        queue: self._dispatch,
                        delay: self._timeout(state),
                        block: { [weak self] in
                            guard let self = self else { return }
                            self._handle()
                        }
                    )
                }
            }
        })
    }
    
}

extension DelayOperator : @unchecked Sendable {
}

private extension DelayOperator {
    
    func _handle() {
        self._lock.perform({
            for state in self._queue {
                self._next.send(state)
            }
            self._queue.removeAll(keepingCapacity: true)
            self._task = nil
        })
    }
    
    func _cancel() {
        self._lock.perform({
            self._next.cancel()
        })
    }
    
}

public extension BuilderTrait {
    
    func delay(
        queue: DispatchQueue,
        timeout: @escaping @Sendable (Tail.OutputState) -> Time
    ) -> BuilderChain<
        Head,
        DelayOperator< Tail.Output >
    > {
        return self.append(.init(queue, timeout))
    }
    
    func delay(
        qos: DispatchQoS.QoSClass,
        timeout: @escaping @Sendable (Tail.OutputState) -> Time
    ) -> BuilderChain<
        Head,
        DelayOperator< Tail.Output >
    > {
        return self.append(.init(.global(qos: qos), timeout))
    }
    
}

