//
//  KindKit
//

import Foundation

extension Slot.Args {
    
    final class Sender< Sender : AnyObject, Result, Argument > : Slot.Args.Base< Result, Argument > {
        
        unowned var signal: ISignal?
        unowned var sender: Sender!
        let closure: (Sender, Argument) -> Result
        
        init(
            _ signal: ISignal,
            _ sender: Sender,
            _ closure: @escaping (Sender, Argument) -> Result
        ) {
            self.signal = signal
            self.sender = sender
            self.closure = closure
            super.init()
        }
        
        deinit {
            self.cancel()
        }
        
        override func perform(_ argument: Argument) -> Result {
            return self.closure(self.sender, argument)
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
