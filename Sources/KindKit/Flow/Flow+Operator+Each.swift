//
//  KindKit
//

import Foundation

public extension Flow.Operator {
    
    final class Each< Input : IFlowResult > : IFlowOperator where Input.Success : Swift.Sequence {
        
        public typealias Input = Input
        public typealias Output = Result< Input.Success.Element, Input.Failure >
        
        private var _next: IFlowPipe!
        
        init() {
        }
        
        public func subscribe(next: IFlowPipe) {
            self._next = next
        }
        
        public func receive(value: Input.Success) {
            for item in value {
                self._next.send(value: item)
            }
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
    
    func each() -> Flow.Chain< Head, Flow.Operator.Each< Tail.Output > > where
        Tail.Output.Success : Sequence
    {
        return self.append(.init())
    }
    
}
