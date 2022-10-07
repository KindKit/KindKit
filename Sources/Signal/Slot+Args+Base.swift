//
//  KindKit
//

import Foundation

extension Slot.Args {
    
    class Base< Result, Argument > : Slot.Base {
        
        func perform(_ argument: Argument) -> Result {
            fatalError()
        }
        
    }
    
}
