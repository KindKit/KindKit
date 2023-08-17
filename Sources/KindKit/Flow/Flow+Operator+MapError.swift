//
//  KindKit
//

import Foundation

public extension Flow.Operator {
    
    final class MapError< Input : IFlowResult, Transform : Swift.Error > : IFlowOperator {
        
        public typealias Input = Input
        public typealias Output = Result< Input.Success, Transform >
        
        private let _perform: (Input.Failure) -> Output.Failure
        private var _next: IFlowPipe!
        
        init(
            _ perform: @escaping (Input.Failure) -> Output.Failure
        ) {
            self._perform = perform
        }
        
        public func subscribe(next: IFlowPipe) {
            self._next = next
        }
        
        public func receive(value: Input.Success) {
            self._next.send(value: value)
        }
        
        public func receive(error: Input.Failure) {
            self._next.send(error: self._perform(error))
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
    
    func mapError<
        Transform : Swift.Error
    >(
        _ perform: @escaping (Tail.Output.Failure) -> Transform
    ) -> Flow.Chain< Head, Flow.Operator.MapError< Tail.Output, Transform > > {
        return self.append(.init(perform))
    }
    
}
