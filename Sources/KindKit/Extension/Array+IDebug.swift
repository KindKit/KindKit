//
//  KindKit
//

import Foundation

extension Array : IDebug {
    
    public func debugInfo() -> Debug.Info {
        return .sequence(self.map({ .cast($0) }))
    }

}
