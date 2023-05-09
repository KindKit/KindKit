//
//  KindKit
//

import Foundation

extension NSDictionary : IDebug {
    
    public func debugInfo() -> Debug.Info {
        return .sequence(self.map({ .pair(cast: $0.key, cast: $0.value) }))
    }

}
