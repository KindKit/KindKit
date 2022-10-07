//
//  KindKit
//

import Foundation

extension Slot.Empty {
    
    class Base< Result > : Slot.Base {
        
        func perform() -> Result {
            fatalError()
        }
        
    }
    
}
