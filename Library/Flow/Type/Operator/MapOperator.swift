//
//  KindKit
//

import KindCore

public final class MapOperator< Input : ResultTrait, Output : ResultTrait > : Operator {
    
    public typealias Input = Input
    public typealias Output = Output
    public typealias Map = @Sendable (InputResult) -> OutputResult?
    
    private let _map: Map
    private var _next: (any Pipe)!
    
    init(
        _ map: @escaping Map
    ) {
        self._map = map
    }
    
    public func connect(next: any Pipe) {
        self._next = next
    }
    
    public func receive(_ state: InputState) {
        switch state {
        case .result(let result):
            guard let result = self._map(result) else { return }
            self._next.send(result)
        case .control(let control):
            switch control {
            case .completed: self._next.completed()
            case .canceled: self._next.cancel()
            }
        }
    }
    
}

extension MapOperator : @unchecked Sendable {
}

public extension BuilderTrait {
    
    func map<
        Success,
        Failure : Swift.Error
    >(
        _ map: @escaping @Sendable (Tail.OutputResult) -> Result< Success, Failure >
    ) -> BuilderChain<
        Head,
        MapOperator< Tail.Output, Result< Success, Failure > >
    > {
        return self.append(.init(map))
    }
    
    func map< Success >(
        value function: @escaping @Sendable (Tail.Output.Success) -> Success
    ) -> BuilderChain<
        Head,
        MapOperator< Tail.Output, Result< Success, Tail.Output.Failure > >
    > {
        return self.append(.init({ input in
            switch input {
            case .success(let value): return .success(function(value))
            case .failure(let error): return .failure(error)
            }
        }))
    }
    
    func map< Failure : Swift.Error >(
        error function: @escaping @Sendable (Tail.Output.Failure) -> Failure
    ) -> BuilderChain<
        Head,
        MapOperator< Tail.Output, Result< Tail.Output.Success, Failure > >
    > {
        return self.append(.init({ input in
            switch input {
            case .success(let value): return .success(value)
            case .failure(let error): return .failure(function(error))
            }
        }))
    }
    
}

public extension BuilderTrait where Tail.Output.Failure == Never {
    
    func map< Success, Failure : Swift.Error >(
        value function: @escaping @Sendable (Tail.Output.Success) -> Result< Success, Failure >
    ) -> BuilderChain<
        Head,
        MapOperator< Tail.Output, Result< Success, Failure > >
    > {
        return self.append(.init({ input in
            switch input {
            case .success(let value): return function(value)
            case .failure: fatalError()
            }
        }))
    }
    
}

