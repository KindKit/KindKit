//
//  KindKit
//

import Foundation

public extension Flow.Operator {
    
    final class Each< Input : IFlowResult > : IFlowOperator where Input.Success : Sequence {
        
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

extension IFlowOperator {
    
    func each(
    ) -> Flow.Operator.Each< Output > where
        Output.Success : Sequence
    {
        let next = Flow.Operator.Each< Output >()
        self.subscribe(next: next)
        return next
    }
    
}

public extension Flow.Builder {
    
    func each(
    ) -> Flow.Head.Builder< Flow.Operator.Each< Input > > where
        Input.Success : Sequence
    {
        return .init(head: .init())
    }
    
}

public extension Flow.Head.Builder {
    
    func each(
    ) -> Flow.Chain.Builder< Head, Flow.Operator.Each< Head.Output > > where
        Head.Output.Success : Sequence
    {
        return .init(head: self.head, tail: self.head.each())
    }
}

public extension Flow.Chain.Builder {
    
    func each(
    ) -> Flow.Chain.Builder< Head, Flow.Operator.Each< Tail.Output > > where
        Tail.Output.Success : Sequence
    {
        return .init(head: self.head, tail: self.tail.each())
    }
    
}
