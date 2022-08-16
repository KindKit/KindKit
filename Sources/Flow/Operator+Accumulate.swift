//
//  KindKitFlow
//

import Foundation

public extension Operator {
    
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
    
    func accumulate() -> Operator.Accumulate< Output > {
        let next = Operator.Accumulate< Output >()
        self.subscribe(next: next)
        return next
    }
    
}

public extension Flow {
    
    func accumulate() -> Builder.Head< Operator.Accumulate< Input > > {
        return .init(head: .init())
    }
    
}

public extension Builder.Head {
    
    func accumulate() -> Builder.Chain< Head, Operator.Accumulate< Head.Output > > {
        return .init(head: self.head, tail: self.head.accumulate())
    }
}

public extension Builder.Chain {
    
    func accumulate() -> Builder.Chain< Head, Operator.Accumulate< Tail.Output > > {
        return .init(head: self.head, tail: self.tail.accumulate())
    }
    
}
