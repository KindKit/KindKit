//
//  KindKit
//

import Foundation

extension Set : IDebug {
    
    public func debugInfo() -> Debug.Info {
        return .sequence(self.map({ .cast($0) }))
    }

}
