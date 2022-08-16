//
//  KindKitApi
//

import Foundation
import KindKitFlow

public extension Api.Flow {
    
    enum Validation {
        
        case retry(delay: TimeInterval)
        case done
        
    }
        
}
