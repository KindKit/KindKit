//
//  KindKitFlow
//

import Foundation

public extension Operator {
    
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

public extension Operator.DispatchMode {
    
    var queue: DispatchQueue {
        switch self {
        case .main: return DispatchQueue.main
        case .background: return DispatchQueue(label: "KindKitFlow.Operator.Dispatch", attributes: [ .concurrent ])
        }
    }
    
}

extension IFlowOperator {
    
    func dispatch(
        _ mode: Operator.DispatchMode
    ) -> Operator.Dispatch< Output > {
        let next = Operator.Dispatch< Output >(mode)
        self.subscribe(next: next)
        return next
    }
    
}

public extension Flow {
    
    func dispatch(
        _ mode: Operator.DispatchMode
    ) -> Builder.Head< Operator.Dispatch< Input > > {
        return .init(head: .init(mode))
    }
    
}

public extension Builder.Head {
    
    func dispatch(
        _ mode: Operator.DispatchMode
    ) -> Builder.Chain< Head, Operator.Dispatch< Head.Output > > {
        return .init(head: self.head, tail: self.head.dispatch(mode))
    }
    
}

public extension Builder.Chain {
    
    func dispatch(
        _ mode: Operator.DispatchMode
    ) -> Builder.Chain< Head, Operator.Dispatch< Tail.Output > > {
        return .init(head: self.head, tail: self.tail.dispatch(mode))
    }
    
}
