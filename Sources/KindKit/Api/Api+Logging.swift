//
//  KindKit
//

import Foundation

public extension Api {
    
    enum Logging {
        
        case never
        case errorOnly(category: String)
        case always(category: String)
        
    }
    
}
