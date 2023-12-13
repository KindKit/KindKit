//
//  KindKit
//

import Foundation

public protocol IFlowPipe : ICancellable {

    func send(value: Any)
    func send(error: Any)
    
    func completed()
    
}

public extension IFlowPipe {
    
    @inlinable
    func send< Success, Failure : Swift.Error >(_ input: Result< Success, Failure >) {
        switch input {
        case .success(let value): self.send(value: value)
        case .failure(let error): self.send(error: error)
        }
    }
    
    @inlinable
    func send< Success, Failure : Swift.Error >(_ input: Result< Success, Failure >?) {
        switch input {
        case .some(let result): self.send(result)
        case .none: break
        }
    }
    
}
