//
//  KindKit
//

import KindCore
import KindEvent
import KindMonadicMacro

@Monadic
public protocol FlowTrait : CancelTrait, Sendable {
    
    associatedtype Input : ResultTrait
    associatedtype Output : ResultTrait
    
    typealias InputState = State< Input >
    typealias InputResult = Result< Input.Success, Input.Failure >
    typealias OutputState = State< Output >
    typealias OutputResult = Result< Output.Success, Output.Failure >
    
    @MonadicSignal
    var onReceive: Signal< Void, State< Output > > { get }
    
    func send(_ state: State< Input >)
    
}

public extension FlowTrait {
    
    @inlinable
    func send(_ result: Result< Input.Success, Input.Failure >){
        switch result {
        case .success(let value): self.send(.result(.success(value)))
        case .failure(let error): self.send(.result(.failure(error)))
        }
    }
    
    @inlinable
    func send(value: Input.Success) {
        self.send(.result(.success(value)))
    }
    
    @inlinable
    func send() where Input.Success == Void {
        self.send(.result(.success))
    }
    
    @inlinable
    func send(error: Input.Failure) {
        self.send(.result(.failure(error)))
    }
    
    @inlinable
    func send(_ control: Control) {
        self.send(.control(control))
    }
    
    @inlinable
    func completed() {
        self.send(.completed)
    }
    
    @inlinable
    func cancel() {
        self.send(.canceled)
    }
    
}

public extension FlowTrait {
    
    @inlinable
    @discardableResult
    func perform(_ input: Result< Input.Success, Input.Failure >) -> Self {
        self.send(input)
        self.completed()
        return self
    }
    
    @inlinable
    @discardableResult
    func perform(_ input: Input.Success) -> Self {
        self.send(value: input)
        self.completed()
        return self
    }
    
    @inlinable
    @discardableResult
    func perform() -> Self where Input.Success == Void {
        self.send(value: ())
        self.completed()
        return self
    }
    
}
