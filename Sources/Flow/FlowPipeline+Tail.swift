//
//  KindKit
//

import Foundation

extension FlowPipeline {
    
    final class Tail : IFlowPipe {
        
        unowned var pipeline: FlowPipeline?
        
        init< Tail : IFlowOperator >(_ tail: Tail) {
            tail.subscribe(next: self)
        }
        
        func send(value: Any) {
            self.pipeline?.tailReceive(value: value as! FlowPipeline.Output.Success)
        }
        
        func send(error: Any) {
            self.pipeline?.tailReceive(error: error as! FlowPipeline.Output.Failure)
        }
        
        func completed() {
            self.pipeline?.tailCompleted()
        }
        
        func cancel() {
        }
        
    }
    
}
