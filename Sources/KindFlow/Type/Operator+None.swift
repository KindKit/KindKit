//
//  KindKit
//

import Foundation

public extension Operator {
    
    final class None< Input : IResult > : IOperator {
        
        public typealias Input = Input
        public typealias Output = Input
        
        private var _next: IPipe!
        
        init() {
        }
        
        public func subscribe(next: IPipe) {
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

public extension IBuilder {
    
    func none() -> Chain< Head, Operator.None< Tail.Output > > {
        return self.append(.init())
    }
    
}
