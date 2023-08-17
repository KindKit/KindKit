//
//  KindKit
//

import Foundation

public protocol IFlowPipeline : ICancellable {
    
    associatedtype Input : IFlowResult
    associatedtype Output : IFlowResult
    
    func subscribe(
        onReceiveValue: @escaping (Output.Success) -> Void,
        onReceiveError: @escaping (Output.Failure) -> Void,
        onCompleted: (() -> Void)?
    ) -> IFlowSubscription
    
    func send(value: Input.Success)
    func send(error: Input.Failure)
    
    func completed()
    
}

public extension IFlowPipeline {
    
    @inlinable
    func subscribe(
        onReceive: @escaping (Result< Output.Success, Output.Failure >) -> Void,
        onCompleted: (() -> Void)? = nil
    ) -> IFlowSubscription {
        return self.subscribe(
            onReceiveValue: { onReceive(.success($0)) },
            onReceiveError: { onReceive(.failure($0)) },
            onCompleted: onCompleted
        )
    }
    
    @inlinable
    func subscribe(
        onReceiveValue: @escaping (Output.Success) -> Void,
        onReceiveError: @escaping (Output.Failure) -> Void,
        onCompleted: (() -> Void)? = nil
    ) -> IFlowSubscription {
        return self.subscribe(
            onReceiveValue: onReceiveValue,
            onReceiveError: onReceiveError,
            onCompleted: onCompleted
        )
    }
    
}

public extension IFlowPipeline {
    
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

public extension IFlowPipeline where Input.Success == Void {
    
    @inlinable
    @discardableResult
    func perform() -> Self {
        self.send(value: ())
        self.completed()
        return self
    }
    
}
