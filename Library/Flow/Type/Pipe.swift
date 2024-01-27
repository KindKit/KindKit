//
//  KindKit
//

import KindCore

public protocol Pipe : CancelTrait, Sendable {

    func send(value: Any)
    func send(error: Any)
    
    func completed()
    
}

public extension Pipe {
    
    @inlinable
    func send< Result : ResultTrait >(_ state: State< Result >) {
        switch state {
        case .result(let result): self.send(result)
        case .control(let control): self.send(control)
        }
    }
    
    @inlinable
    func send< Success, Failure : Swift.Error >(_ result: Result< Success, Failure >) {
        switch result {
        case .success(let value): self.send(value: value)
        case .failure(let error): self.send(error: error)
        }
    }
    
    @inlinable
    func send(_ control: Control) {
        switch control {
        case .completed: self.completed()
        case .canceled: self.cancel()
        }
    }
    
}
