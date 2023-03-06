//
//  KindKit
//

import Foundation

public protocol IFlowOperator : IFlowPipe {
    
    associatedtype Input : IFlowResult
    associatedtype Output : IFlowResult
    
    func subscribe(next: IFlowPipe)

    func receive(value: Input.Success)
    func receive(error: Input.Failure)
    
}

public extension IFlowOperator {
    
    func send(value: Any) {
        self.receive(value: value as! Input.Success)
    }
    
    func send(error: Any) {
        self.receive(error: error as! Input.Failure)
    }
    
}
