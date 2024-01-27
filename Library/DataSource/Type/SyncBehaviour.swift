//
//  KindKit
//

import Foundation
import KindMeasure

public enum SyncBehaviour {
    
    case permanent
    case periodic(Time)
    
}

public extension SyncBehaviour {
    
    @inlinable
    func isNeedSync(_ syncAt: Date?) -> Bool {
        guard let syncAt = syncAt else { return true }
        switch self {
        case .permanent:
            return false
        case .periodic(let timeout):
            let delta = .now - Time(date: syncAt)
            return delta >= timeout
        }
    }
    
}
