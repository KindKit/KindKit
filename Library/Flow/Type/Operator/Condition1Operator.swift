//
//  KindKit
//

import KindCore

public final class Condition1Operator< Input : ResultTrait, Flow : FlowTrait > : Operator {
    
    public typealias Input = Input
    public typealias Output = Flow.Output
    public typealias Resolver = @Sendable (InputResult) -> Resolve
    
    private let _flow: Flow
    private let _resolver: Resolver
    private var _last: Resolve?
    private var _next: (any Pipe)!
    
    fileprivate init(
        _ flow: Flow,
        _ resolver: @escaping Resolver
    ) {
        self._flow = flow
        self._resolver = resolver
        
        self._flow.onReceive(target: self, regular: { $0._next.send($1) })
    }
    
    public func connect(next: any Pipe) {
        self._next = next
    }
    
    public func receive(_ state: InputState) {
        switch state {
        case .result(let result):
            let resolve = self._resolver(result)
            self._last = resolve
            switch resolve {
            case .next(let result): self._flow.send(result)
            case .skip(let result): self._next.send(result)
            }
        case .control(let control):
            let last = self._last
            self._last = nil
            switch last {
            case .next: self._flow.send(control)
            case .skip: self._next.send(control)
            case .none: self._next.send(control)
            }
        }
    }
    
}

extension Condition1Operator : @unchecked Sendable {
}

public extension Condition1Operator {
    
    enum Resolve {
        
        case next(Flow.InputResult)
        case skip(OutputResult)
        
    }
    
}

public extension BuilderTrait {

    func condition< Then : FlowTrait >(
        `if`: @escaping @Sendable (Tail.OutputResult) -> Bool,
        then: Then
    ) -> BuilderChain<
        Head,
        Condition1Operator< Tail.Output, Then >
    > where
        Tail.Output.Success == Then.Input.Success,
        Tail.Output.Failure == Then.Input.Failure,
        Then.Input == Then.Output
    {
        return self.append(.init(then, { input in
            switch input {
            case .success(let value):
                switch `if`(input) {
                case true: return .next(.success(value))
                case false: return .skip(.success(value))
                }
            case .failure(let error):
                switch `if`(input) {
                case true: return .next(.failure(error))
                case false: return .skip(.failure(error))
                }
            }
        }))
    }
    
    func unwrap< Else : FlowTrait >(
        `else`: Else
    ) -> BuilderChain<
        Head,
        Condition1Operator< Tail.Output, Else >
    > where
        Tail.Output.Success : OptionalTrait,
        Tail.Output.Success.Wrapped == Else.Output.Success,
        Tail.Output.Failure == Else.Input.Failure,
        Else.Input.Success == Void
    {
        return self.append(.init(`else`, { input in
            switch input {
            case .success(let value):
                if let value = value.asOptional {
                    return .skip(.success(value))
                } else {
                    return .next(.success)
                }
            case .failure(let error):
                return .next(.failure(error))
            }
        }))
    }

}
