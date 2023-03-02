//
//  KindKit
//

import Foundation

public extension RemoteImage.Flow {
    
    enum Validation {
        
        case retry(delay: TimeInterval)
        case done
        
    }
        
}
