//
//  KindKit
//

import Foundation

public extension Api.Flow {
    
    enum Validation {
        
        case retry(delay: TimeInterval)
        case done
        
    }
        
}
