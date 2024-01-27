//
//  KindKit
//

import Foundation
import KindTime

public extension Sync {
    
    enum Behaviour {
        
        case permanent
        case periodic(SecondsInterval)
        
    }
        
}

public extension Sync.Behaviour {
    
    @inlinable
    func isNeedSync(_ syncAt: Date?) -> Bool {
        guard let syncAt = syncAt else { return true }
        switch self {
        case .permanent:
            return false
        case .periodic(let timeout):
            let delta = SecondsInterval(syncAt).delta(from: .now)
            return delta >= timeout
        }
    }
    
}
