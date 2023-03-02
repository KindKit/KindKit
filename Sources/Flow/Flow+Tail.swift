//
//  KindKit
//

import Foundation

extension Flow {
    
    final class Tail< Input : IFlowResult, Output : IFlowResult > : IFlowPipe {
        
        typealias Success = Output.Success
        typealias Failure = Output.Failure
        typealias Pipeline = Flow.Pipeline< Input, Output >
        
        weak var pipeline: Pipeline?
        
        init< Tail : IFlowOperator >(_ tail: Tail) {
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
    
}
