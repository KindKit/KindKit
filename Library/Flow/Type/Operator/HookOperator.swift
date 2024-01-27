//
//  KindKit
//

import KindCore

public final class HookOperator< Input : ResultTrait > : Operator {
    
    public typealias Input = Input
    public typealias Output = Input
    public typealias Hook = @Sendable (InputState) -> Void
    
    private let _receive: Hook
    private var _next: (any Pipe)!
    
    fileprivate init(
        _ receive: @escaping Hook
    ) {
        self._receive = receive
    }
    
    public func connect(next: any Pipe) {
        self._next = next
    }
    
    public func receive(_ state: InputState) {
        self._receive(state)
        self._next.send(state)
    }
    
}

extension HookOperator : @unchecked Sendable {
}

public extension BuilderTrait {
    
    func hook(
        onValue: @escaping @Sendable (Tail.Output.Success) -> Void
    ) -> BuilderChain<
        Head,
        HookOperator< Tail.Output >
    > {
        return self.append(.init({
            guard let value = $0.success else { return }
            onValue(value)
        }))
    }
    
    func hook(
        onError: @escaping @Sendable (Tail.Output.Failure) -> Void
    ) -> BuilderChain<
        Head,
        HookOperator< Tail.Output >
    > {
        return self.append(.init({
            guard let error = $0.failure else { return }
            onError(error)
        }))
    }
    
}

public extension BuilderTrait {
    
    func hook(
        onCompleted: @escaping @Sendable () -> Void
    ) -> BuilderChain<
        Head,
        HookOperator< Tail.Output >
    > {
        return self.append(.init({
            guard $0.isCompleted else { return }
            onCompleted()
        }))
    }
    
    func hook(
        onCanceled: @escaping @Sendable () -> Void
    ) -> BuilderChain<
        Head,
        HookOperator< Tail.Output >
    > {
        return self.append(.init({
            guard $0.isCanceled else { return }
            onCanceled()
        }))
    }
    
    func hook(
        onControl: @escaping @Sendable (Control) -> Void
    ) -> BuilderChain<
        Head,
        HookOperator< Tail.Output >
    > {
        return self.append(.init({
            guard case .control(let control) = $0 else { return }
            onControl(control)
        }))
    }
    
}

public extension BuilderTrait {
    
    func hook(
        onValue: @escaping @Sendable (Tail.Output.Success) -> Void,
        onError: @escaping @Sendable (Tail.Output.Failure) -> Void
    ) -> BuilderChain<
        Head,
        HookOperator< Tail.Output >
    > {
        return self.append(.init({
            guard case .result(let result) = $0 else { return }
            switch result {
            case .success(let value): onValue(value)
            case .failure(let error): onError(error)
            }
        }))
    }
    
    func hook(
        onValue: @escaping @Sendable (Tail.Output.Success) -> Void,
        onCompleted: @escaping @Sendable () -> Void
    ) -> BuilderChain<
        Head,
        HookOperator< Tail.Output >
    > {
        return self.append(.init({
            switch $0 {
            case .result(let result):
                switch result {
                case .success(let value): onValue(value)
                case .failure: break
                }
            case .control(let control):
                switch control {
                case .completed: onCompleted()
                case .canceled: break
                }
            }
        }))
    }
    
    func hook(
        onValue: @escaping @Sendable (Tail.Output.Success) -> Void,
        onCanceled: @escaping @Sendable () -> Void
    ) -> BuilderChain<
        Head,
        HookOperator< Tail.Output >
    > {
        return self.append(.init({
            switch $0 {
            case .result(let result):
                switch result {
                case .success(let value): onValue(value)
                case .failure: break
                }
            case .control(let control):
                switch control {
                case .completed: break
                case .canceled: onCanceled()
                }
            }
        }))
    }
    
}

public extension BuilderTrait {
    
    func hook(
        onError: @escaping @Sendable (Tail.Output.Failure) -> Void,
        onCompleted: @escaping @Sendable () -> Void
    ) -> BuilderChain<
        Head,
        HookOperator< Tail.Output >
    > {
        return self.append(.init({
            switch $0 {
            case .result(let result):
                switch result {
                case .success: break
                case .failure(let error): onError(error)
                }
            case .control(let control):
                switch control {
                case .completed: onCompleted()
                case .canceled: break
                }
            }
        }))
    }
    
    func hook(
        onError: @escaping @Sendable (Tail.Output.Failure) -> Void,
        onCanceled: @escaping @Sendable () -> Void
    ) -> BuilderChain<
        Head,
        HookOperator< Tail.Output >
    > {
        return self.append(.init({
            switch $0 {
            case .result(let result):
                switch result {
                case .success: break
                case .failure(let error): onError(error)
                }
            case .control(let control):
                switch control {
                case .completed: break
                case .canceled: onCanceled()
                }
            }
        }))
    }
    
}

public extension BuilderTrait {
    
    func hook(
        onValue: @escaping @Sendable (Tail.Output.Success) -> Void,
        onError: @escaping @Sendable (Tail.Output.Failure) -> Void,
        onCompleted: @escaping @Sendable () -> Void
    ) -> BuilderChain<
        Head,
        HookOperator< Tail.Output >
    > {
        return self.append(.init({
            switch $0 {
            case .result(let result):
                switch result {
                case .success(let value): onValue(value)
                case .failure(let error): onError(error)
                }
            case .control(let control):
                switch control {
                case .completed: onCompleted()
                case .canceled: break
                }
            }
        }))
    }
    
    func hook(
        onValue: @escaping @Sendable (Tail.Output.Success) -> Void,
        onError: @escaping @Sendable (Tail.Output.Failure) -> Void,
        onCanceled: @escaping @Sendable () -> Void
    ) -> BuilderChain<
        Head,
        HookOperator< Tail.Output >
    > {
        return self.append(.init({
            switch $0 {
            case .result(let result):
                switch result {
                case .success(let value): onValue(value)
                case .failure(let error): onError(error)
                }
            case .control(let control):
                switch control {
                case .completed: break
                case .canceled: onCanceled()
                }
            }
        }))
    }
    
    func hook(
        onValue: @escaping @Sendable (Tail.Output.Success) -> Void,
        onError: @escaping @Sendable (Tail.Output.Failure) -> Void,
        onCompleted: @escaping @Sendable () -> Void,
        onCanceled: @escaping @Sendable () -> Void
    ) -> BuilderChain<
        Head,
        HookOperator< Tail.Output >
    > {
        return self.append(.init({
            switch $0 {
            case .result(let result):
                switch result {
                case .success(let value): onValue(value)
                case .failure(let error): onError(error)
                }
            case .control(let control):
                switch control {
                case .completed: onCompleted()
                case .canceled: onCanceled()
                }
            }
        }))
    }
    
}

public extension BuilderTrait {
    
    func hook(
        onReceive: @escaping @Sendable (Tail.OutputResult) -> Void
    ) -> BuilderChain<
        Head,
        HookOperator< Tail.Output >
    > {
        return self.append(.init({
            guard case .result(let result) = $0 else { return }
            onReceive(result)
        }))
    }
    
    func hook(
        onReceive: @escaping @Sendable (Tail.OutputResult) -> Void,
        onCompleted: @escaping @Sendable () -> Void
    ) -> BuilderChain<
        Head,
        HookOperator< Tail.Output >
    > {
        return self.append(.init({
            switch $0 {
            case .result(let result): onReceive(result)
            case .control(let control):
                switch control {
                case .completed: onCompleted()
                case .canceled: break
                }
            }
        }))
    }
    
    func hook(
        onReceive: @escaping @Sendable (Tail.OutputResult) -> Void,
        onCanceled: @escaping @Sendable () -> Void
    ) -> BuilderChain<
        Head,
        HookOperator< Tail.Output >
    > {
        return self.append(.init({
            switch $0 {
            case .result(let result): onReceive(result)
            case .control(let control):
                switch control {
                case .completed: break
                case .canceled: onCanceled()
                }
            }
        }))
    }
    
    func hook(
        onReceive: @escaping @Sendable (Tail.OutputResult) -> Void,
        onCompleted: @escaping @Sendable () -> Void,
        onCanceled: @escaping @Sendable () -> Void
    ) -> BuilderChain<
        Head,
        HookOperator< Tail.Output >
    > {
        return self.append(.init({
            switch $0 {
            case .result(let result): onReceive(result)
            case .control(let control):
                switch control {
                case .completed: onCompleted()
                case .canceled: onCanceled()
                }
            }
        }))
    }
    
}

public extension BuilderTrait {
    
    func hook(
        onCompleted: @escaping @Sendable () -> Void,
        onCanceled: @escaping @Sendable () -> Void
    ) -> BuilderChain<
        Head,
        HookOperator< Tail.Output >
    > {
        return self.append(.init({
            guard case .control(let control) = $0 else { return }
            switch control {
            case .completed: onCompleted()
            case .canceled: onCanceled()
            }
        }))
    }
    
}
