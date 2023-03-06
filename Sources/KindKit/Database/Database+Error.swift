//
//  KindKit
//

import Foundation

public extension Database {
    
    enum Error : Swift.Error {
        
        case unableLocation(Database.Location)
        case failQuery(String)
        case columnNotFound(String)
        case decode
        case `internal`(Internal)
        
    }
        
}
