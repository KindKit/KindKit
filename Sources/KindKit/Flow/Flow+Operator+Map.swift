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
        
        private let _function: (Result< Input.Success, Input.Failure >) -> Output
        private var _next: IFlowPipe!
        
        init(
            _ function: @escaping (Result< Input.Success, Input.Failure >) -> Output
        ) {
            self._function = function
        }
        
        public func subscribe(next: IFlowPipe) {
            self._next = next
        }
        
        public func receive(value: Input.Success) {
            self._receive(.success(value))
        }
        
        public func receive(error: Input.Failure) {
            self._receive(.failure(error))
        }
        
        public func completed() {
            self._next.completed()
        }
        
        public func cancel() {
            self._next.cancel()
        }
        
    }
    
}

private extension Flow.Operator.Map {
    
    func _receive(_ input: Result< Input.Success, Input.Failure >) {
        switch self._function(input) {
        case .success(let value):
            self._next.send(value: value)
        case .failure(let error):
            self._next.send(error: error)
        }
    }
    
}

public extension IFlowBuilder {
    
    func map<
        Success,
        Failure : Swift.Error
    >(
        _ function: @escaping (Result< Tail.Output.Success, Tail.Output.Failure >) -> Result< Success, Failure >
    ) -> Flow.Chain< Head, Flow.Operator.Map< Tail.Output, Success, Failure > > {
        return self.append(.init(function))
    }
    
    func map<
        Success,
        Failure : Swift.Error
    >(
        value function: @escaping (Tail.Output.Success) -> Result< Success, Failure >
    ) -> Flow.Chain< Head, Flow.Operator.Map< Tail.Output, Success, Failure > > where Tail.Output.Failure == Never {
        return self.append(.init({ input in
            switch input {
            case .success(let value): return function(value)
            case .failure: fatalError()
            }
        }))
    }
    
    func map<
        Success
    >(
        value function: @escaping (Tail.Output.Success) -> Success
    ) -> Flow.Chain< Head, Flow.Operator.Map< Tail.Output, Success, Tail.Output.Failure > > {
        return self.append(.init({ input in
            switch input {
            case .success(let value): return .success(function(value))
            case .failure(let error): return .failure(error)
            }
        }))
    }
    
    func map<
        Failure : Swift.Error
    >(
        error function: @escaping (Tail.Output.Failure) -> Failure
    ) -> Flow.Chain< Head, Flow.Operator.Map< Tail.Output, Tail.Output.Success, Failure > > {
        return self.append(.init({ input in
            switch input {
            case .success(let value): return .success(value)
            case .failure(let error): return .failure(function(error))
            }
        }))
    }
    
}

public extension IFlowBuilder {
    
    @available(*, deprecated, renamed: "IFlowBuilder.map(value:)")
    func mapValue<
        Transform
    >(
        _ perform: @escaping (Tail.Output.Success) -> Transform
    ) -> Flow.Chain< Head, Flow.Operator.Map< Tail.Output, Transform, Tail.Output.Failure > > {
        return self.map(value: perform)
    }
    
    @available(*, deprecated, renamed: "IFlowBuilder.map(error:)")
    func mapError<
        Transform : Swift.Error
    >(
        _ perform: @escaping (Tail.Output.Failure) -> Transform
    ) -> Flow.Chain< Head, Flow.Operator.Map< Tail.Output, Tail.Output.Success, Transform > > {
        return self.map(error: perform)
    }
    
}
