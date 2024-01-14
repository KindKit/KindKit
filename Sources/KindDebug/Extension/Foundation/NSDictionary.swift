//
//  KindKit
//

import Foundation

extension NSDictionary : IEntity {
    
    public func debugInfo() -> Info {
        return .sequence(self.map({ .pair(cast: $0.key, cast: $0.value) }))
    }

}
