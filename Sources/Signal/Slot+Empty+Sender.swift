//
//  KindKit
//

import Foundation

extension Slot.Empty {
    
    final class Sender< Sender : AnyObject, Result > : Slot.Empty.Base< Result > {
        
        unowned var signal: ISignal?
        unowned var sender: Sender!
        let closure: (Sender) -> Result
        
        init(
            _ signal: ISignal,
            _ sender: Sender,
            _ closure: @escaping (Sender) -> Result
        ) {
            self.signal = signal
            self.sender = sender
            self.closure = closure
            super.init()
        }
        
        deinit {
            self.cancel()
        }
        
        override func perform() -> Result {
            return self.closure(self.sender)
        }
        
        override func cancel() {
            self.signal?.remove(self)
            self.reset()
        }
        
        override func reset() {
            self.signal = nil
            self.sender = nil
        }
        
    }
    
}
