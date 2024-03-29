//
//  KindKit
//

import Foundation

public extension Flow.Operator {
    
    final class Dispatch< Value : IFlowResult > : IFlowOperator {
        
        public typealias Input = Value
        public typealias Output = Value
        
        private let _lock = Lock()
        private let _queue: DispatchQueue
        private var _stack: [Item] = []
        private var _task: ICancellable?
        private var _next: IFlowPipe!
        
        init(
            _ queue: DispatchQueue
        ) {
            self._queue = queue
        }
        
        init(
            _ global: DispatchQoS.QoSClass
        ) {
            self._queue = .global(qos: global)
        }
        
        public func subscribe(next: IFlowPipe) {
            self._next = next
        }
        
        public func receive(value: Input.Success) {
            self._push(.value(value))
        }
        
        public func receive(error: Input.Failure) {
            self._push(.error(error))
        }
        
        public func completed() {
            self._push(.completed)
        }
        
        public func cancel() {
            self._push(.cancel)
        }
        
    }
    
}

private extension Flow.Operator.Dispatch {
    
    enum Item {
        
        case value(Input.Success)
        case error(Input.Failure)
        case completed
        case cancel
        
    }
    
}

private extension Flow.Operator.Dispatch {
    
    func _push(_ item: Item) {
        self._lock.perform({
            self._stack.append(item)
            self._start()
        })
    }
    
    func _start() {
        guard self._task == nil else { return }
        self._task = DispatchWorkItem.kk_async(
            queue: self._queue,
            block: { [weak self] in self?._handle() }
        )
    }
    
    func _handle() {
        self._lock.perform({
            for item in self._stack {
                switch item {
                case .value(let value):
                    self._next.send(value: value)
                case .error(let error):
                    self._next.send(error: error)
                case .completed:
                    self._next.completed()
                case .cancel:
                    self._next.cancel()
                }
            }
            self._stack.removeAll(keepingCapacity: true)
            self._task = nil
        })
    }
    
}

public extension IFlowBuilder {
    
    func dispatch(
        _ queue: DispatchQueue
    ) -> Flow.Chain< Head, Flow.Operator.Dispatch< Tail.Output > > {
        return self.append(.init(queue))
    }
    
    func dispatch(
        global: DispatchQoS.QoSClass
    ) -> Flow.Chain< Head, Flow.Operator.Dispatch< Tail.Output > > {
        return self.append(.init(global))
    }
    
}
