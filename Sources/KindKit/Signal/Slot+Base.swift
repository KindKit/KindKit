//
//  KindKit
//

import Foundation

extension Slot {
    
    class Base : ISlot {
        
        init() {
        }
        
        deinit {
            self.cancel()
        }
        
        func cancel() {
            fatalError()
        }
                
        func reset() {
            fatalError()
        }
        
    }
    
}
