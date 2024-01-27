//
//  KindKit
//

import KindCore

public protocol Operator : Pipe {
    
    associatedtype Input : ResultTrait
    associatedtype Output : ResultTrait
    
    typealias InputState = State< Input >
    typealias InputResult = Result< Input.Success, Input.Failure >
    typealias OutputState = State< Output >
    typealias OutputResult = Result< Output.Success, Output.Failure >
    
    func connect(next: any Pipe)

    func receive(_ state: InputState)
    
}

public extension Operator {
    
    func send(value: Any) {
        self.receive(.success(value as! Input.Success))
    }
    
    func send(error: Any) {
        self.receive(.failure(error as! Input.Failure))
    }
    
    func completed() {
        self.receive(.completed)
    }
    
    func cancel() {
        self.receive(.canceled)
    }
    
}
