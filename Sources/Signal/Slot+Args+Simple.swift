//
//  KindKit
//

import Foundation

extension Slot.Args {
    
    final class Simple< Result, Argument > : Slot.Args.Base< Result, Argument > {
        
        unowned var signal: ISignal?
        let closure: (Argument) -> Result
        
        init(
            _ signal: ISignal,
            _ closure: @escaping (Argument) -> Result
        ) {
            self.signal = signal
            self.closure = closure
            super.init()
        }
        
        deinit {
            self.cancel()
        }
        
        override func perform(_ argument: Argument) -> Result {
            return self.closure(argument)
        }
        
        override func cancel() {
            self.signal?.remove(self)
            self.reset()
        }
        
        override func reset() {
            self.signal = nil
        }
        
    }
    
}
