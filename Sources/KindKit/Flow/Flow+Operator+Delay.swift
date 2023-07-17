//
//  KindKit
//

import Foundation

public extension Flow.Operator {
    
    final class Delay< Value : IFlowResult > : IFlowOperator {
        
        public typealias Input = Value
        public typealias Output = Value
        
        private let _queue: DispatchQueue
        private let _timeout: (Result< Value.Success, Value.Failure >) -> TimeInterval
        private var _task: DispatchWorkItem?
        private var _next: IFlowPipe!
        
        init(
            _ queue: DispatchQueue,
            _ timeout: @escaping (Result< Value.Success, Value.Failure >) -> TimeInterval
        ) {
            self._queue = queue
            self._timeout = timeout
        }
        
        deinit {
            self._task?.cancel()
        }
        
        public func subscribe(next: IFlowPipe) {
            self._next = next
        }
        
        public func receive(value: Input.Success) {
            self._task = DispatchWorkItem.kk_async(
                queue: self._queue,
                delay: self._timeout(.success(value)),
                block: { [weak self] in
                    guard let self = self else { return }
                    self._task = nil
                    self._next.send(value: value)
                    self._next.completed()
                }
            )
        }
        
        public func receive(error: Input.Failure) {
            self._task = DispatchWorkItem.kk_async(
                queue: self._queue,
                delay: self._timeout(.failure(error)),
                block: { [weak self] in
                    guard let self = self else { return }
                    self._task = nil
                    self._next.send(error: error)
                    self._next.completed()
                }
            )
        }
        
        public func completed() {
        }
        
        public func cancel() {
            self._queue.async(flags: .barrier, execute: {
                self._task?.cancel()
                self._task = nil
                self._next.cancel()
            })
        }
        
    }
    
}

extension IFlowOperator {
    
    func delay(
        _ queue: DispatchQueue,
        _ timeout: @escaping (Result< Output.Success, Output.Failure >) -> TimeInterval
    ) -> Flow.Operator.Delay< Output > {
        let next = Flow.Operator.Delay< Output >(queue, timeout)
        self.subscribe(next: next)
        return next
    }
    
}

public extension Flow.Builder {
    
    func delay(
        queue: DispatchQueue,
        timeout: @escaping (Result< Input.Success, Input.Failure >) -> TimeInterval
    ) -> Flow.Head.Builder< Flow.Operator.Delay< Input > > {
        return .init(head: .init(queue, timeout))
    }
    
}

public extension Flow.Head.Builder {
    
    func delay(
        queue: DispatchQueue,
        timeout: @escaping (Result< Head.Output.Success, Head.Output.Failure >) -> TimeInterval
    ) -> Flow.Chain.Builder< Head, Flow.Operator.Delay< Head.Output > > {
        return .init(head: self.head, tail: self.head.delay(queue, timeout))
    }
    
}

public extension Flow.Chain.Builder {
    
    func delay(
        queue: DispatchQueue,
        timeout: @escaping (Result< Tail.Output.Success, Tail.Output.Failure >) -> TimeInterval
    ) -> Flow.Chain.Builder< Head, Flow.Operator.Delay< Tail.Output > > {
        return .init(head: self.head, tail: self.tail.delay(queue, timeout))
    }
    
}
