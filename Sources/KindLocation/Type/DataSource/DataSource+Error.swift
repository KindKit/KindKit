//
//  KindKit
//

public extension DataSource {
    
    enum Error : Swift.Error {
        
        case serviceUnavailable
        case permissionDenied
        case error(Swift.Error)
        
    }
        
}
