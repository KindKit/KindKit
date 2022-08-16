//
//  KindKitDataSource
//

import Foundation

public extension DataSource.Sync {
    
    enum Behaviour {
        
        case permanent
        case periodic(TimeInterval)
        
    }
        
}

public extension DataSource.Sync.Behaviour {
    
    @inlinable
    func isNeedSync(_ syncAt: Date?) -> Bool {
        guard let syncAt = syncAt else { return true }
        switch self {
        case .permanent:
            return false
        case .periodic(let timeout):
            return Date().timeIntervalSince(syncAt) >= timeout
        }
    }
    
}
