//
//  KindKit
//

import Foundation

public extension Operator {
    
    final class Delay< Value : IResult > : IOperator {
        
        public typealias Input = Value
        public typealias Output = Value
        
        private let _lock = Lock()
        private let _queue: DispatchQueue
        private let _timeout: (Item) -> TimeInterval
        private var _stack: [Item] = []
        private var _task: ICancellable?
        private var _next: IPipe!
        
        init(
            _ queue: DispatchQueue,
            _ timeout: @escaping (Item) -> TimeInterval
        ) {
            self._queue = queue
            self._timeout = timeout
        }
        
        init(
            _ global: DispatchQoS.QoSClass,
            _ timeout: @escaping (Item) -> TimeInterval
        ) {
            self._queue = .global(qos: global)
            self._timeout = timeout
        }
        
        public func subscribe(next: IPipe) {
            self._next = next
        }
        
        public func receive(value: Input.Success) {
            self._push(.success(value))
        }
        
        public func receive(error: Input.Failure) {
            self._push(.failure(error))
        }
        
        public func completed() {
            self._push(.completed)
        }
        
        public func cancel() {
            self._push(.cancel)
        }
        
    }
    
}

public extension Operator.Delay {
    
    enum Item {
        
        case success(Input.Success)
        case failure(Input.Failure)
        case completed
        case cancel
        
    }
    
}

private extension Operator.Delay {
    
    func _push(_ item: Item) {
        self._lock.perform({
            self._stack.append(item)
            self._start(item)
        })
    }
    
    func _start(_ item: Item) {
        guard self._task == nil else { return }
        self._task = DispatchWorkItem.kk_async(
            queue: self._queue,
            delay: self._timeout(item),
            block: { [weak self] in self?._handle() }
        )
    }
    
    func _handle() {
        self._lock.perform({
            for item in self._stack {
                switch item {
                case .success(let value):
                    self._next.send(value: value)
                case .failure(let error):
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

public extension IBuilder {
    
    func delay(
        queue: DispatchQueue,
        timeout: @escaping (Operator.Delay< Tail.Output >.Item) -> TimeInterval
    ) -> Chain< Head, Operator.Delay< Tail.Output > > {
        return self.append(.init(queue, timeout))
    }
    
    func delay(
        global: DispatchQoS.QoSClass,
        timeout: @escaping (Operator.Delay< Tail.Output >.Item) -> TimeInterval
    ) -> Chain< Head, Operator.Delay< Tail.Output > > {
        return self.append(.init(global, timeout))
    }
    
}

