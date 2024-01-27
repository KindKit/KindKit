//
//  KindKit
//

import KindCore

public final class Condition2Operator<
    Input : ResultTrait,
    Flow1 : FlowTrait,
    Flow2 : FlowTrait
> : Operator {
    
    public typealias Input = Input
    public typealias Output = Flow1.Output
    public typealias Resolver = @Sendable (InputResult) -> Resolve
    
    private let _flow1: Flow1
    private let _flow2: Flow2
    private let _resolver: Resolver
    private var _last: Resolve?
    private var _next: (any Pipe)!
    
    fileprivate init(
        _ flow1: Flow1,
        _ flow2: Flow2,
        _ resolver: @escaping Resolver
    ) {
        self._flow1 = flow1
        self._flow2 = flow2
        self._resolver = resolver
        
        self._flow1.onReceive(target: self, regular: { $0._next.send($1) })
        
        self._flow2.onReceive(target: self, regular: { $0._next.send($1) })
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
            case .next1(let result): self._flow1.send(result)
            case .next2(let result): self._flow2.send(result)
            }
        case .control(let control):
            let last = self._last
            self._last = nil
            switch last {
            case .next1: self._flow1.send(control)
            case .next2: self._flow2.send(control)
            case .none: self._next.send(control)
            }
        }
    }
    
}

extension Condition2Operator : @unchecked Sendable {
}

public extension Condition2Operator {
    
    enum Resolve {
        
        case next1(Flow1.InputResult)
        case next2(Flow2.InputResult)
        
    }
    
}

public extension BuilderTrait {
    
    func condition<
        Then : FlowTrait,
        Else : FlowTrait
    >(
        `if`: @escaping @Sendable (Tail.OutputResult) -> Bool,
        then: Then,
        `else`: Else
    ) -> BuilderChain<
        Head,
        Condition2Operator< Tail.Output, Then, Else >
    > where
        Tail.Output.Success == Then.Input.Success,
        Tail.Output.Success == Else.Input.Success,
        Tail.Output.Failure == Then.Input.Failure,
        Tail.Output.Failure == Else.Input.Failure,
        Then.Output == Else.Output
    {
        return self.append(.init(then, `else`, { input in
            switch input {
            case .success(let value):
                switch `if`(input) {
                case true: return .next1(.success(value))
                case false: return .next2(.success(value))
                }
            case .failure(let error):
                switch `if`(input) {
                case true: return .next1(.failure(error))
                case false: return .next2(.failure(error))
                }
            }
        }))
    }
    
    func unwrap<
        Then : FlowTrait,
        Else : FlowTrait
    >(
        then: Then,
        `else`: Else
    ) -> BuilderChain<
        Head,
        Condition2Operator< Tail.Output, Then, Else >
    > where
        Tail.Output.Success : OptionalTrait,
        Tail.Output.Success.Wrapped == Then.Input.Success,
        Tail.Output.Failure == Then.Input.Failure,
        Tail.Output.Failure == Else.Input.Failure,
        Else.Input.Success == Void,
        Then.Output == Else.Output
    {
        return self.append(.init(then, `else`, { input in
            switch input {
            case .success(let value):
                if let value = value.asOptional {
                    return .next1(.success(value))
                } else {
                    return .next2(.success)
                }
            case .failure(let error):
                return .next1(.failure(error))
            }
        }))
    }
    
}

public extension BuilderTrait where Tail.Output.Failure == Never {
    
    func condition<
        Then : FlowTrait,
        Else : FlowTrait
    >(
        `if`: @escaping @Sendable (Tail.OutputResult) -> Bool,
        then: Then,
        `else`: Else
    ) -> BuilderChain<
        Head,
        Condition2Operator< Tail.Output, Then, Else >
    > where
        Tail.Output.Success == Then.Input.Success,
        Tail.Output.Success == Else.Input.Success,
        Then.Output == Else.Output
    {
        return self.append(.init(then, `else`, { input in
            switch input {
            case .success(let value):
                switch `if`(input) {
                case true: return .next1(.success(value))
                case false: return .next2(.success(value))
                }
            case .failure:
                fatalError()
            }
        }))
    }
    
}
