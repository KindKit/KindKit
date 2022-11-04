//
//  KindKit
//

import Foundation

extension Slot.Empty {
    
    final class Sender< Sender : AnyObject, Result > : Slot.Empty.Base< Result > {
        
        weak var signal: ISignal?
        weak var sender: Sender!
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
        
        override func perform() throws -> Result {
            guard let sender = self.sender else { throw Slot.Error.notHaveSender }
            return self.closure(sender)
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
