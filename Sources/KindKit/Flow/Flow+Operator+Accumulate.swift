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

public extension IFlowBuilder {
    
    func accumulate() -> Flow.Chain< Head, Flow.Operator.Accumulate< Tail.Output > > {
        return self.append(.init())
    }
    
}
