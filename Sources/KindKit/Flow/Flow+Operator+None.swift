//
//  KindKit
//

import Foundation

public extension Flow.Operator {
    
    final class None< Input : IFlowResult > : IFlowOperator {
        
        public typealias Input = Input
        public typealias Output = Input
        
        private var _next: IFlowPipe!
        
        init() {
        }
        
        public func subscribe(next: IFlowPipe) {
            self._next = next
        }
        
        public func receive(value: Input.Success) {
            self._next.send(value: value)
        }
        
        public func receive(error: Input.Failure) {
            self._next.send(error: error)
        }
        
        public func completed() {
            self._next.completed()
        }
        
        public func cancel() {
            self._next.cancel()
        }
        
    }
    
}

public extension IFlowBuilder {
    
    func none() -> Flow.Chain< Head, Flow.Operator.None< Tail.Output > > {
        return self.append(.init())
    }
    
}
