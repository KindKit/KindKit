//
//  KindKit
//

import Foundation

public extension Flow.Operator {
    
    final class Dispatch< Value : IFlowResult > : IFlowOperator {
        
        public typealias Input = Value
        public typealias Output = Value
        
        private let _queue: DispatchQueue
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
            self._queue.async(execute: { [weak self] in
                guard let self = self else { return }
                self._next.send(value: value)
            })
        }
        
        public func receive(error: Input.Failure) {
            self._queue.async(execute: { [weak self] in
                guard let self = self else { return }
                self._next.send(error: error)
            })
        }
        
        public func completed() {
            self._queue.async(flags: .barrier, execute: { [weak self] in
                guard let self = self else { return }
                self._next.completed()
            })
        }
        
        public func cancel() {
            self._queue.async(flags: .barrier, execute: { [weak self] in
                guard let self = self else { return }
                self._next.cancel()
            })
        }
        
    }
    
}

extension IFlowOperator {
    
    func dispatch(
        _ queue: DispatchQueue
    ) -> Flow.Operator.Dispatch< Output > {
        let next = Flow.Operator.Dispatch< Output >(queue)
        self.subscribe(next: next)
        return next
    }
    
    func dispatch(
        _ global: DispatchQoS.QoSClass
    ) -> Flow.Operator.Dispatch< Output > {
        let next = Flow.Operator.Dispatch< Output >(global)
        self.subscribe(next: next)
        return next
    }
    
}

public extension Flow.Builder {
    
    func dispatch(
        _ queue: DispatchQueue
    ) -> Flow.Head.Builder< Flow.Operator.Dispatch< Input > > {
        return .init(head: .init(queue))
    }
    
    func dispatch(
        global: DispatchQoS.QoSClass
    ) -> Flow.Head.Builder< Flow.Operator.Dispatch< Input > > {
        return .init(head: .init(global))
    }
    
}

public extension Flow.Head.Builder {
    
    func dispatch(
        _ queue: DispatchQueue
    ) -> Flow.Chain.Builder< Head, Flow.Operator.Dispatch< Head.Output > > {
        return .init(head: self.head, tail: self.head.dispatch(queue))
    }
    
    func dispatch(
        global: DispatchQoS.QoSClass
    ) -> Flow.Chain.Builder< Head, Flow.Operator.Dispatch< Head.Output > > {
        return .init(head: self.head, tail: self.head.dispatch(global))
    }
    
}

public extension Flow.Chain.Builder {
    
    func dispatch(
        _ queue: DispatchQueue
    ) -> Flow.Chain.Builder< Head, Flow.Operator.Dispatch< Tail.Output > > {
        return .init(head: self.head, tail: self.tail.dispatch(queue))
    }
    
    func dispatch(
        global: DispatchQoS.QoSClass
    ) -> Flow.Chain.Builder< Head, Flow.Operator.Dispatch< Tail.Output > > {
        return .init(head: self.head, tail: self.tail.dispatch(global))
    }
    
}
