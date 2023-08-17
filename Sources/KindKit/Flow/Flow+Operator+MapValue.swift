//
//  KindKit
//

import Foundation

public extension Flow.Operator {
    
    final class MapValue< Input : IFlowResult, Transform > : IFlowOperator {
        
        public typealias Input = Input
        public typealias Output = Result< Transform, Input.Failure >
        
        private let _perform: (Input.Success) -> Transform
        private var _next: IFlowPipe!
        
        init(
            _ perform: @escaping (Input.Success) -> Transform
        ) {
            self._perform = perform
        }
        
        public func subscribe(next: IFlowPipe) {
            self._next = next
        }
        
        public func receive(value: Input.Success) {
            self._next.send(value: self._perform(value))
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
    
    func mapValue<
        Transform
    >(
        _ perform: @escaping (Tail.Output.Success) -> Transform
    ) -> Flow.Chain< Head, Flow.Operator.MapValue< Tail.Output, Transform > > {
        return self.append(.init(perform))
    }
    
}
