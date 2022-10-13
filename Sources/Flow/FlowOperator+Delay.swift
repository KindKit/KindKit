//
//  KindKit
//

import Foundation

public extension FlowOperator {
    
    final class Delay< Value : IFlowResult > : IFlowOperator {
        
        public typealias Input = Value
        public typealias Output = Value
        
        private let _queue: DispatchQueue
        private let _timeout: (Result< Value.Success, Value.Failure >) -> TimeInterval
        private var _task: DispatchWorkItem?
        private var _next: IFlowPipe!
        
        init(
            _ mode: DispatchMode,
            _ timeout: @escaping (Result< Value.Success, Value.Failure >) -> TimeInterval
        ) {
            self._queue = mode.queue
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
                block: { [unowned self] in
                    self._task = nil
                    self._next.send(value: value)
                    self._next.completed()
                },
                queue: self._queue,
                delay: self._timeout(.success(value))
            )
        }
        
        public func receive(error: Input.Failure) {
            self._task = DispatchWorkItem.kk_async(
                block: { [unowned self] in
                    self._task = nil
                    self._next.send(error: error)
                    self._next.completed()
                },
                queue: self._queue,
                delay: self._timeout(.failure(error))
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
        dispatch: FlowOperator.DispatchMode,
        timeout: @escaping (Result< Output.Success, Output.Failure >) -> TimeInterval
    ) -> FlowOperator.Delay< Output > {
        let next = FlowOperator.Delay< Output >(dispatch, timeout)
        self.subscribe(next: next)
        return next
    }
    
}

public extension Flow {
    
    func delay(
        dispatch: FlowOperator.DispatchMode,
        timeout: @escaping (Result< Input.Success, Input.Failure >) -> TimeInterval
    ) -> FlowBuilder.Head< FlowOperator.Delay< Input > > {
        return .init(head: .init(dispatch, timeout))
    }
    
}

public extension FlowBuilder.Head {
    
    func delay(
        dispatch: FlowOperator.DispatchMode,
        timeout: @escaping (Result< Head.Output.Success, Head.Output.Failure >) -> TimeInterval
    ) -> FlowBuilder.Chain< Head, FlowOperator.Delay< Head.Output > > {
        return .init(head: self.head, tail: self.head.delay(
            dispatch: dispatch,
            timeout: timeout
        ))
    }
    
}

public extension FlowBuilder.Chain {
    
    func delay(
        dispatch: FlowOperator.DispatchMode,
        timeout: @escaping (Result< Tail.Output.Success, Tail.Output.Failure >) -> TimeInterval
    ) -> FlowBuilder.Chain< Head, FlowOperator.Delay< Tail.Output > > {
        return .init(head: self.head, tail: self.tail.delay(
            dispatch: dispatch,
            timeout: timeout
        ))
    }
    
}
