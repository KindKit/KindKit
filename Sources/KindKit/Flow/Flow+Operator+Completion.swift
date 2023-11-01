//
//  KindKit
//

import Foundation

public extension Flow.Operator {
    
    final class Completion< Input : IFlowResult, Success, Failure : Swift.Error > : IFlowOperator {
        
        public typealias Input = Input
        public typealias Output = Result< Success, Failure >
        
        private let _function: (Result< Input.Success, Input.Failure >, @escaping (Result< Success, Failure >) -> Void) -> Void
        private var _next: IFlowPipe!
        
        init(
            _ function: @escaping (Result< Input.Success, Input.Failure >, @escaping (Result< Success, Failure >) -> Void) -> Void
        ) {
            self._function = function
        }
        
        public func subscribe(next: IFlowPipe) {
            self._next = next
        }
        
        public func receive(value: Input.Success) {
            self._function(.success(value), { [weak self] input in
                self?._receive(result: input)
            })
        }
        
        public func receive(error: Input.Failure) {
            self._function(.failure(error), { [weak self] input in
                self?._receive(result: input)
            })
        }
        
        public func completed() {
        }
        
        public func cancel() {
            self._next.cancel()
        }
        
    }
    
}

private extension Flow.Operator.Completion {
    
    func _receive(result: Result< Success, Failure >) {
        switch result {
        case .success(let value): self._next.send(value: value)
        case .failure(let error): self._next.send(error: error)
        }
        self._next.completed()
    }
    
}

public extension IFlowBuilder {
    
    func completion<
        Success,
        Failure : Swift.Error
    >(
        _ function: @escaping (Result< Tail.Output.Success, Tail.Output.Failure >, @escaping (Result< Success, Failure >) -> Void) -> Void
    ) -> Flow.Chain< Head, Flow.Operator.Completion< Tail.Output, Success, Failure > > {
        return self.append(.init(function))
    }
    
    func completion<
        Success,
        Failure : Swift.Error
    >(
        _ function: @escaping (Tail.Output.Success, @escaping (Result< Success, Failure >) -> Void) -> Void
    ) -> Flow.Chain< Head, Flow.Operator.Completion< Tail.Output, Success, Failure > > where Tail.Output.Failure == Never {
        return self.append(.init({ input, completion in
            switch input {
            case .success(let value): function(value, completion)
            case .failure: fatalError()
            }
        }))
    }
    
    func completion<
        Success
    >(
        _ function: @escaping (Tail.Output.Success, @escaping (Success) -> Void) -> Void
    ) -> Flow.Chain< Head, Flow.Operator.Completion< Tail.Output, Success, Never > > where Tail.Output.Failure == Never {
        return self.append(.init({ input, completion in
            switch input {
            case .success(let value): function(value, { completion(.success($0)) })
            case .failure: fatalError()
            }
        }))
    }
    
    func completion<
        Success
    >(
        value function: @escaping (Tail.Output.Success, @escaping (Result< Success, Tail.Output.Failure >) -> Void) -> Void
    ) -> Flow.Chain< Head, Flow.Operator.Completion< Tail.Output, Success, Tail.Output.Failure > > {
        return self.append(.init({ input, completion in
            switch input {
            case .success(let value): function(value, completion)
            case .failure(let error): completion(.failure(error))
            }
        }))
    }
    
    func completion<
        Failure : Swift.Error
    >(
        error function: @escaping (Tail.Output.Failure, @escaping (Result< Tail.Output.Success, Failure >) -> Void) -> Void
    ) -> Flow.Chain< Head, Flow.Operator.Completion< Tail.Output, Tail.Output.Success, Failure > > {
        return self.append(.init({ input, completion in
            switch input {
            case .success(let value): completion(.success(value))
            case .failure(let error): function(error, completion)
            }
        }))
    }
    
}
