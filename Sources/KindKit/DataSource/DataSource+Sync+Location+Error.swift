//
//  KindKit
//

#if canImport(CoreLocation)

public extension DataSource.Sync.Location {
    
    enum Error : Swift.Error {
        
        case serviceUnavailable
        case permissionDenied
        case error(Swift.Error)
        
    }
        
}

#endif
