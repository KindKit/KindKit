//
//  KindKit
//

import Foundation

public extension Flow.Operator {
    
    final class Accumulate< Input : IFlowResult > : IFlowOperator {
        
        public typealias Input = Input
        public typealias Output = Result< [Input.Success], Input.Failure >
        
        private var _value: [Input.Success]
        private var _error: Input.Failure?
        private var _next: IFlowPipe!
        
        init() {
            self._value = []
        }
        
        public func subscribe(next: IFlowPipe) {
            self._next = next
        }
        
        public func receive(value: Input.Success) {
            self._value.append(value)
        }
        
        public func receive(error: Input.Failure) {
            self._error = error
        }
        
        public func completed() {
            if let error = self._error {
                self._next.send(error: error)
            } else {
                self._next.send(value: self._value)
            }
            self._next.completed()
        }
        
        public func cancel() {
            self._value.removeAll()
            self._error = nil
            self._next.cancel()
        }
        
    }
    
}

extension IFlowOperator {
    
    func accumulate() -> Flow.Operator.Accumulate< Output > {
        let next = Flow.Operator.Accumulate< Output >()
        self.subscribe(next: next)
        return next
    }
    
}

public extension Flow.Builder {
    
    func accumulate() -> Flow.Head.Builder< Flow.Operator.Accumulate< Input > > {
        return .init(head: .init())
    }
    
}

public extension Flow.Head.Builder {
    
    func accumulate() -> Flow.Chain.Builder< Head, Flow.Operator.Accumulate< Head.Output > > {
        return .init(head: self.head, tail: self.head.accumulate())
    }
}

public extension Flow.Chain.Builder {
    
    func accumulate() -> Flow.Chain.Builder< Head, Flow.Operator.Accumulate< Tail.Output > > {
        return .init(head: self.head, tail: self.tail.accumulate())
    }
    
}
