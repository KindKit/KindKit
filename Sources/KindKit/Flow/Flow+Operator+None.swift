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

extension IFlowOperator {
    
    func none() -> Flow.Operator.None< Output > {
        let next = Flow.Operator.None< Output >()
        self.subscribe(next: next)
        return next
    }
    
}

public extension Flow.Builder {
    
    func none() -> Flow.Head.Builder< Flow.Operator.None< Input > > {
        return .init(head: .init())
    }
    
}

public extension Flow.Head.Builder {
    
    func none() -> Flow.Chain.Builder< Head, Flow.Operator.None< Head.Output > > {
        return .init(head: self.head, tail: self.head.none())
    }
}

public extension Flow.Chain.Builder {
    
    func none() -> Flow.Chain.Builder< Head, Flow.Operator.None< Tail.Output > > {
        return .init(head: self.head, tail: self.tail.none())
    }
    
}
