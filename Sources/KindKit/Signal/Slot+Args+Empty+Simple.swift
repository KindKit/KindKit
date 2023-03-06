//
//  KindKit
//

import Foundation

extension Slot.Args.Empty {
    
    final class Simple< Result, Argument > : Slot.Args.Base< Result, Argument > {
        
        weak var signal: ISignal?
        let closure: () -> Result
        
        init(
            _ signal: ISignal,
            _ closure: @escaping () -> Result
        ) {
            self.signal = signal
            self.closure = closure
            super.init()
        }
        
        deinit {
            self.cancel()
        }
        
        override func perform(_ argument: Argument) throws -> Result {
            return self.closure()
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
