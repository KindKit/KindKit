//
//  KindKit
//

import Foundation

extension NSArray : IDebug {
    
    public func debugInfo() -> Debug.Info {
        return .sequence(self.map({ .cast($0) }))
    }

}
