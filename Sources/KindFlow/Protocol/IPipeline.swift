//
//  KindKit
//

public protocol IPipeline : ICancellable {
    
    associatedtype Input : IResult
    associatedtype Output : IResult
    
    func subscribe(
        onReceiveValue: @escaping (Output.Success) -> Void,
        onReceiveError: @escaping (Output.Failure) -> Void,
        onCompleted: (() -> Void)?
    ) -> ISubscription
    
    func send(value: Input.Success)
    func send(error: Input.Failure)
    
    func completed()
    
}

public extension IPipeline {
    
    @inlinable
    func subscribe(
        onReceive: @escaping (Result< Output.Success, Output.Failure >) -> Void,
        onCompleted: (() -> Void)? = nil
    ) -> ISubscription {
        return self.subscribe(
            onReceiveValue: { onReceive(.success($0)) },
            onReceiveError: { onReceive(.failure($0)) },
            onCompleted: onCompleted
        )
    }
    
    @inlinable
    func subscribe(
        onReceive: @escaping (Output.Success) -> Void,
        onCompleted: (() -> Void)? = nil
    ) -> ISubscription where Output.Failure == Never {
        return self.subscribe(
            onReceiveValue: { onReceive($0) },
            onReceiveError: { _ in },
            onCompleted: onCompleted
        )
    }
    
    @inlinable
    func subscribe(
        onReceiveValue: @escaping (Output.Success) -> Void,
        onReceiveError: @escaping (Output.Failure) -> Void,
        onCompleted: (() -> Void)? = nil
    ) -> ISubscription {
        return self.subscribe(
            onReceiveValue: onReceiveValue,
            onReceiveError: onReceiveError,
            onCompleted: onCompleted
        )
    }
    
}

public extension IPipeline {
    
    @inlinable
    @discardableResult
    func send(_ input: Result< Input.Success, Input.Failure >) -> Self {
        switch input {
        case .success(let value): self.send(value: value)
        case .failure(let error): self.send(error: error)
        }
        return self
    }
    
    @inlinable
    @discardableResult
    func perform(_ input: Result< Input.Success, Input.Failure >) -> Self {
        self.send(input).completed()
        return self
    }
    
    @inlinable
    @discardableResult
    func perform(_ input: Input.Success) -> Self {
        self.send(value: input)
        self.completed()
        return self
    }
    
}

public extension IPipeline where Input.Success == Void {
    
    @inlinable
    @discardableResult
    func perform() -> Self {
        self.send(value: ())
        self.completed()
        return self
    }
    
}
