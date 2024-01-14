//
//  KindKit
//

public enum Error : Swift.Error {
    
    case unableLocation(Location)
    case failQuery(String)
    case columnNotFound(String)
    case decode
    case `internal`(Internal)
    
}
