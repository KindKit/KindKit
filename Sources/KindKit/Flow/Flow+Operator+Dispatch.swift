//
//  KindKit
//

import Foundation

public extension Flow.Operator {
    
    enum DispatchMode {
        
        case main
        case background
        
    }
    
    final class Dispatch< Value : IFlowResult > : IFlowOperator {
        
        public typealias Input = Value
        public typealias Output = Value
        
        private let _queue: DispatchQueue
        private var _next: IFlowPipe!
        
        init(
            _ mode: DispatchMode
        ) {
            self._queue = mode.queue
        }
        
        public func subscribe(next: IFlowPipe) {
            self._next = next
        }
        
        public func receive(value: Input.Success) {
            self._queue.async(flags: .barrier, execute: {
                self._next.send(value: value)
            })
        }
        
        public func receive(error: Input.Failure) {
            self._queue.async(flags: .barrier, execute: {
                self._next.send(error: error)
            })
        }
        
        public func completed() {
            self._queue.async(flags: .barrier, execute: {
                self._next.completed()
            })
        }
        
        public func cancel() {
            self._queue.async(flags: .barrier, execute: {
                self._next.cancel()
            })
        }
        
    }
    
}

public extension Flow.Operator.DispatchMode {
    
    var queue: DispatchQueue {
        switch self {
        case .main: return DispatchQueue.main
        case .background: return DispatchQueue(label: "KindKit.Flow.Operator.Dispatch", attributes: .concurrent)
        }
    }
    
}

extension IFlowOperator {
    
    func dispatch(
        _ mode: Flow.Operator.DispatchMode
    ) -> Flow.Operator.Dispatch< Output > {
        let next = Flow.Operator.Dispatch< Output >(mode)
        self.subscribe(next: next)
        return next
    }
    
}

public extension Flow.Builder {
    
    func dispatch(
        _ mode: Flow.Operator.DispatchMode
    ) -> Flow.Head.Builder< Flow.Operator.Dispatch< Input > > {
        return .init(head: .init(mode))
    }
    
}

public extension Flow.Head.Builder {
    
    func dispatch(
        _ mode: Flow.Operator.DispatchMode
    ) -> Flow.Chain.Builder< Head, Flow.Operator.Dispatch< Head.Output > > {
        return .init(head: self.head, tail: self.head.dispatch(mode))
    }
    
}

public extension Flow.Chain.Builder {
    
    func dispatch(
        _ mode: Flow.Operator.DispatchMode
    ) -> Flow.Chain.Builder< Head, Flow.Operator.Dispatch< Tail.Output > > {
        return .init(head: self.head, tail: self.tail.dispatch(mode))
    }
    
}
