//
//  KindKit
//

import Dispatch
import KindCore

public final class DispatchOperator< Value : ResultTrait > : Operator {
    
    public typealias Input = Value
    public typealias Output = Value
    
    private let _lock = RecursiveLock()
    private let _dispatch: DispatchQueue
    private var _queue: [InputState] = []
    private var _task: CancelTrait?
    private var _next: (any Pipe)!
    
    fileprivate init(
        _ dispatch: DispatchQueue
    ) {
        self._dispatch = dispatch
    }
    
    public func connect(next: any Pipe) {
        self._next = next
    }
    
    public func receive(_ state: InputState) {
        self._lock.perform({
            self._queue.append(state)
            if self._task == nil {
                self._task = DispatchWorkItem.async(
                    queue: self._dispatch,
                    block: { [weak self] in self?._handle() }
                )
            }
        })
    }
    
}

extension DispatchOperator : @unchecked Sendable {
}

private extension DispatchOperator {
    
    func _handle() {
        self._lock.perform({
            for state in self._queue {
                self._next.send(state)
            }
            self._queue.removeAll(keepingCapacity: true)
            self._task = nil
        })
    }
    
}

public extension BuilderTrait {
    
    func dispatch(
        queue: DispatchQueue
    ) -> BuilderChain<
        Head,
        DispatchOperator< Tail.Output >
    > {
        return self.append(.init(queue))
    }
    
    func dispatch(
        qos: DispatchQoS.QoSClass
    ) -> BuilderChain<
        Head,
        DispatchOperator< Tail.Output >
    > {
        return self.append(.init(.global(qos: qos)))
    }
    
}
