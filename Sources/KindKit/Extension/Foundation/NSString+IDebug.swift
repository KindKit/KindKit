//
//  KindKit
//

import Foundation

extension NSString : IDebug {
    
    public func debugInfo() -> Debug.Info {
        return (self as String).debugInfo()
    }

}
