//
//  KindKit
//

import Foundation

final class Tail< InputType : IResult, OutputType : IResult > : IPipe {
    
    typealias Success = OutputType.Success
    typealias Failure = OutputType.Failure
    
    weak var pipeline: Pipeline< InputType, OutputType >?
    
    init< TailType : IOperator >(_ tail: TailType) {
        tail.subscribe(next: self)
    }
    
    func send(value: Any) {
        self.pipeline?.tailReceive(value: value as! Success)
    }
    
    func send(error: Any) {
        self.pipeline?.tailReceive(error: error as! Failure)
    }
    
    func completed() {
        self.pipeline?.tailCompleted()
    }
    
    func cancel() {
    }
    
}
