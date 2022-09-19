//
//  KindKit
//

import Foundation

public extension FlowOperator {
    
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

public extension FlowOperator.DispatchMode {
    
    var queue: DispatchQueue {
        switch self {
        case .main: return DispatchQueue.main
        case .background: return DispatchQueue(label: "KindKitFlow.Operator.Dispatch", attributes: [ .concurrent ])
        }
    }
    
}

extension IFlowOperator {
    
    func dispatch(
        _ mode: FlowOperator.DispatchMode
    ) -> FlowOperator.Dispatch< Output > {
        let next = FlowOperator.Dispatch< Output >(mode)
        self.subscribe(next: next)
        return next
    }
    
}

public extension Flow {
    
    func dispatch(
        _ mode: FlowOperator.DispatchMode
    ) -> FlowBuilder.Head< FlowOperator.Dispatch< Input > > {
        return .init(head: .init(mode))
    }
    
}

public extension FlowBuilder.Head {
    
    func dispatch(
        _ mode: FlowOperator.DispatchMode
    ) -> FlowBuilder.Chain< Head, FlowOperator.Dispatch< Head.Output > > {
        return .init(head: self.head, tail: self.head.dispatch(mode))
    }
    
}

public extension FlowBuilder.Chain {
    
    func dispatch(
        _ mode: FlowOperator.DispatchMode
    ) -> FlowBuilder.Chain< Head, FlowOperator.Dispatch< Tail.Output > > {
        return .init(head: self.head, tail: self.tail.dispatch(mode))
    }
    
}
