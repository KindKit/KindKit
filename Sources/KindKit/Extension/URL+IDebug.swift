//
//  KindKit
//

import Foundation

extension URL : IDebug {
    
    public func debugInfo() -> Debug.Info {
        return self.absoluteString.debugInfo()
    }

}
