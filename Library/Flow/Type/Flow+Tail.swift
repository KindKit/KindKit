//
//  KindKit
//

import KindCore
import KindEvent

extension Flow {
    
    final class Tail : Pipe {
        
        let onReceive = Signal< Void, State< Output > >()
        
        init< Tail : Operator >(_ tail: Tail) {
            tail.connect(next: self)
        }
        
        func send(value: Any) {
            self.onReceive.emit(.success(value as! Output.Success))
        }
        
        func send(error: Any) {
            self.onReceive.emit(.failure(error as! Output.Failure))
        }
        
        func completed() {
            self.onReceive.emit(.completed)
        }
        
        func cancel() {
            self.onReceive.emit(.canceled)
        }
        
    }
    
}
