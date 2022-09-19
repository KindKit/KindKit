//
//  KindKit
//

import Foundation

public extension FlowOperator {
    
    final class Accumulate< Input : IFlowResult > : IFlowOperator {
        
        public typealias Input = Input
        public typealias Output = Result< Array< Input.Success >, Input.Failure >
        
        private var _accumulator: Array< Input.Success >
        private var _next: IFlowPipe!
        
        init() {
            self._accumulator = []
        }
        
        public func subscribe(next: IFlowPipe) {
            self._next = next
        }
        
        public func receive(value: Input.Success) {
            self._accumulator.append(value)
        }
        
        public func receive(error: Input.Failure) {
            self._next.send(error: error)
        }
        
        public func completed() {
            self._next.send(value: self._accumulator)
            self._next.completed()
        }
        
        public func cancel() {
            self._next.cancel()
        }
        
    }
    
}

extension IFlowOperator {
    
    func accumulate() -> FlowOperator.Accumulate< Output > {
        let next = FlowOperator.Accumulate< Output >()
        self.subscribe(next: next)
        return next
    }
    
}

public extension Flow {
    
    func accumulate() -> FlowBuilder.Head< FlowOperator.Accumulate< Input > > {
        return .init(head: .init())
    }
    
}

public extension FlowBuilder.Head {
    
    func accumulate() -> FlowBuilder.Chain< Head, FlowOperator.Accumulate< Head.Output > > {
        return .init(head: self.head, tail: self.head.accumulate())
    }
}

public extension FlowBuilder.Chain {
    
    func accumulate() -> FlowBuilder.Chain< Head, FlowOperator.Accumulate< Tail.Output > > {
        return .init(head: self.head, tail: self.tail.accumulate())
    }
    
}
