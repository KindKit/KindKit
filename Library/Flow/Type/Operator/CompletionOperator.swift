//
//  KindKit
//

import KindCore

public final class CompletionOperator< Input : ResultTrait, Output : ResultTrait > : Operator {
    
    public typealias Input = Input
    public typealias Output = Output
    public typealias Completion = (InputResult, @escaping @Sendable (OutputResult) -> Void) -> Void
    
    private let _function: Completion
    private var _next: (any Pipe)!
    
    fileprivate init(
        _ function: @escaping Completion
    ) {
        self._function = function
    }
    
    public func connect(next: any Pipe) {
        self._next = next
    }
    
    public func receive(_ state: InputState) {
        switch state {
        case .result(let result):
            self._function(result, { [weak self] result in
                guard let self = self else { return }
                self._next.send(result)
                self._next.completed()
            })
        case .control(let control):
            switch control {
            case .completed: break
            case .canceled: self._next.cancel()
            }
        }
    }
    
}

extension CompletionOperator : @unchecked Sendable {
}

public extension BuilderTrait {
    
    func completion< Success, Failure : Swift.Error >(
        _ function: @escaping (Tail.OutputResult, @escaping @Sendable (Result< Success, Failure >) -> Void) -> Void
    ) -> BuilderChain<
        Head,
        CompletionOperator< Tail.Output, Result< Success, Failure > >
    > {
        return self.append(.init(function))
    }
    
    func completion< Success >(
        value function: @escaping (Tail.Output.Success, @escaping @Sendable (Result< Success, Tail.Output.Failure >) -> Void) -> Void
    ) -> BuilderChain<
        Head,
        CompletionOperator< Tail.Output, Result< Success, Tail.Output.Failure > >
    > {
        return self.append(.init({ input, completion in
            switch input {
            case .success(let value): function(value, completion)
            case .failure(let error): completion(.failure(error))
            }
        }))
    }
    
    func completion< Failure : Swift.Error >(
        error function: @escaping (Tail.Output.Failure, @escaping @Sendable (Result< Tail.Output.Success, Failure >) -> Void) -> Void
    ) -> BuilderChain<
        Head,
        CompletionOperator< Tail.Output, Result< Tail.Output.Success, Failure > >
    > {
        return self.append(.init({ input, completion in
            switch input {
            case .success(let value): completion(.success(value))
            case .failure(let error): function(error, completion)
            }
        }))
    }
    
}

public extension BuilderTrait where Tail.Output.Failure == Never {
    
    func completion< Success, Failure : Swift.Error >(
        _ function: @escaping @Sendable (Tail.Output.Success, @escaping @Sendable (Result< Success, Failure >) -> Void) -> Void
    ) -> BuilderChain<
        Head,
        CompletionOperator< Tail.Output, Result< Success, Failure > >
    > {
        return self.append(.init({ input, completion in
            switch input {
            case .success(let value): function(value, completion)
            case .failure: fatalError()
            }
        }))
    }
    
    func completion< Success >(
        _ function: @escaping @Sendable (Tail.Output.Success, @escaping @Sendable (Success) -> Void) -> Void
    ) -> BuilderChain<
        Head,
        CompletionOperator< Tail.Output, Result< Success, Never > >
    > {
        return self.append(.init({ input, completion in
            switch input {
            case .success(let value): function(value, { completion(.success($0)) })
            case .failure: fatalError()
            }
        }))
    }
    
}
