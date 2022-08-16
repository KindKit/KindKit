//
//  KindKitFlow
//

import Foundation

extension Pipeline {
    
    final class Tail : IFlowPipe {
        
        unowned var pipeline: Pipeline?
        
        init< Tail : IFlowOperator >(_ tail: Tail) {
            tail.subscribe(next: self)
        }
        
        func send(value: Any) {
            self.pipeline?.tailReceive(value: value as! Pipeline.Output.Success)
        }
        
        func send(error: Any) {
            self.pipeline?.tailReceive(error: error as! Pipeline.Output.Failure)
        }
        
        func completed() {
            self.pipeline?.tailCompleted()
        }
        
        func cancel() {
        }
        
    }
    
}
