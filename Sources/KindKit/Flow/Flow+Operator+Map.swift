//
//  KindKit
//

import Foundation

public extension Flow.Operator {
    
    final class Map<
        Input : IFlowResult,
        Success,
        Failure : Swift.Error
    > : IFlowOperator {
        
        public typealias Input = Input
        public typealias Output = Result< Success, Failure >
        
        private let _perform: (Result< Input.Success, Input.Failure >) -> Output
        private var _next: IFlowPipe!
        
        init(
            _ perform: @escaping (Result< Input.Success, Input.Failure >) -> Output
        ) {
            self._perform = perform
        }
        
        public func subscribe(next: IFlowPipe) {
            self._next = next
        }
        
        public func receive(value: Input.Success) {
            switch self._perform(.success(value)) {
            case .success(let value):
                self._next.send(value: value)
            case .failure(let error):
                self._next.send(error: error)
            }
        }
        
        public func receive(error: Input.Failure) {
            switch self._perform(.failure(error)) {
            case .success(let value):
                self._next.send(value: value)
            case .failure(let error):
                self._next.send(error: error)
            }
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
    
    func map<
        Success,
        Failure : Swift.Error
    >(
        _ perform: @escaping (Result< Tail.Output.Success, Tail.Output.Failure >) -> Result< Success, Failure >
    ) -> Flow.Chain< Head, Flow.Operator.Map< Tail.Output, Success, Failure > > {
        return self.append(.init(perform))
    }
    
}
