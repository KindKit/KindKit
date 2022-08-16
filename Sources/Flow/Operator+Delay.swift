//
//  KindKitFlow
//

import Foundation
import KindKitCore

public extension Operator {
    
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
            self._task = DispatchWorkItem.async(
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
            self._task = DispatchWorkItem.async(
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
        dispatch: Operator.DispatchMode,
        timeout: @escaping (Result< Output.Success, Output.Failure >) -> TimeInterval
    ) -> Operator.Delay< Output > {
        let next = Operator.Delay< Output >(dispatch, timeout)
        self.subscribe(next: next)
        return next
    }
    
}

public extension Flow {
    
    func delay(
        dispatch: Operator.DispatchMode,
        timeout: @escaping (Result< Input.Success, Input.Failure >) -> TimeInterval
    ) -> Builder.Head< Operator.Delay< Input > > {
        return .init(head: .init(dispatch, timeout))
    }
    
}

public extension Builder.Head {
    
    func delay(
        dispatch: Operator.DispatchMode,
        timeout: @escaping (Result< Head.Output.Success, Head.Output.Failure >) -> TimeInterval
    ) -> Builder.Chain< Head, Operator.Delay< Head.Output > > {
        return .init(head: self.head, tail: self.head.delay(
            dispatch: dispatch,
            timeout: timeout
        ))
    }
    
}

public extension Builder.Chain {
    
    func delay(
        dispatch: Operator.DispatchMode,
        timeout: @escaping (Result< Tail.Output.Success, Tail.Output.Failure >) -> TimeInterval
    ) -> Builder.Chain< Head, Operator.Delay< Tail.Output > > {
        return .init(head: self.head, tail: self.tail.delay(
            dispatch: dispatch,
            timeout: timeout
        ))
    }
    
}
