//
//  KindKit
//

import Foundation

extension Slot.Empty {
    
    final class Simple< Result > : Slot.Empty.Base< Result > {
        
        unowned var signal: ISignal?
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
        
        override func perform() -> Result {
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
